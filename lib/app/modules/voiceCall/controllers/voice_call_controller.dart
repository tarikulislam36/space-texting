import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class VoiceCallController extends GetxController {
  final localVideoRenderer = webrtc.RTCVideoRenderer();
  final remoteVideoRenderer = webrtc.RTCVideoRenderer();
  RxBool isLoading = true.obs;
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? remoteStream;
  String callId = Get.arguments['callId'] ?? "";
  String receiverId = Get.arguments['receiverId'];
  String? currentRoomText;
  RxBool isSpeakerEnabled = false.obs;
  RxBool isMuted = false.obs;
  RxBool isCallPicked = false.obs;
  RxString callDuration = '00:00'.obs;
  Timer? _timer;
  int _seconds = 0;

  final Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  @override
  void onInit() async {
    print("init state called");
    super.onInit();
    await initRenderers();
    await openUserMedia(localVideoRenderer, remoteVideoRenderer);
    if (Get.arguments['isCaller'] == true) {
      callId = await createRoom(remoteVideoRenderer);
      await FirebaseFirestore.instance.collection('calls').doc(callId).set({
        'callerId': receiverId,
        'receiverId': receiverId,
        'hangUped': false, // Add hangUped field
      });
    } else {
      await joinRoom(callId, remoteVideoRenderer);
    }
    listenForHangUp(); // Listen for hang up changes
    isLoading.value = false;
  }

  Future<void> initRenderers() async {
    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();
  }

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('voiceRooms').doc();

    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await webrtc.createPeerConnection(configuration);
    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };

    webrtc.RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');

    Map<String, dynamic> roomWithOffer = {
      'offer': offer.toMap(),
      'callerId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': receiverId,
      "callId": roomRef.id,
      "createdAt": Timestamp.fromDate(DateTime.now()),
      'hangUped': false, // Add hangUped field
    };

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    print('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';

    peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
      remoteVideoRenderer.srcObject =
          remoteStream; // Assign remote stream to remote renderer
    };

    roomRef.snapshots().listen((snapshot) async {
      print('Got updated room: ${snapshot.data()}');

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = webrtc.RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        print("Someone tried to connect");
        await peerConnection?.setRemoteDescription(answer);
        // Call picked up, start timer
        startCallTimer();
        isCallPicked.value = true;
      }
    });

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          print('Got new remote ICE candidate: ${jsonEncode(data)}');
          peerConnection!.addCandidate(
            webrtc.RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });

    return roomId;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(roomId);
    DocumentReference roomRef = db.collection('voiceRooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await webrtc.createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (webrtc.RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };

      peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
        remoteVideo.srcObject =
            remoteStream; // Assign remote stream to remote renderer
        // Call picked up, start timer
        startCallTimer();
        isCallPicked.value = true;
      };

      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        webrtc.RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);

      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            webrtc.RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await webrtc.navigator.mediaDevices
        .getUserMedia({'video': false, 'audio': true});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await webrtc.createLocalMediaStream('key');
    webrtc.Helper.setSpeakerphoneOn(
        false); // Ensure the call starts with earpiece
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<webrtc.MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (callId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('voiceRooms').doc(callId);

      await roomRef.update({'hangUped': true}); // Update hangUped field

      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((document) => document.reference.delete());

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) => document.reference.delete());

      await roomRef.delete();
    }

    localStream!.dispose();
    remoteStream?.dispose();
    stopCallTimer();
  }

  void listenForHangUp() {
    FirebaseFirestore.instance
        .collection('voiceRooms')
        .doc(callId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()!['hangUped'] == true) {
        Get.back();
      }
    });
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (webrtc.RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (webrtc.RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (webrtc.RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (webrtc.RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (webrtc.MediaStream stream) {
      print("Add remote stream");
      remoteVideoRenderer.srcObject = stream;
      remoteStream = stream;
      // Call picked up, start timer
      startCallTimer();
      isCallPicked.value = true;
    };
  }

  void toggleSpeaker() {
    isSpeakerEnabled.value = !isSpeakerEnabled.value;
    webrtc.Helper.setSpeakerphoneOn(isSpeakerEnabled.value);
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    localStream?.getAudioTracks().forEach((track) {
      track.enabled = !isMuted.value;
    });
  }

  void startCallTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      int minutes = _seconds ~/ 60;
      int seconds = _seconds % 60;
      callDuration.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  void stopCallTimer() {
    _timer?.cancel();
    _timer = null;
    _seconds = 0;
    callDuration.value = '00:00';
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/firebase_options.dart';
import 'package:uuid/uuid.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
  await Firebase
      .initializeApp(); //make sure firebase is initialized before using it (showCallkitIncoming)
  print("Message Type ${message.data["callType"]}");
  if (message.data["callType"] != "text") {
    print("Call called");
    showCallkitIncoming(const Uuid().v4(), message.data);
  }
}

Future<void> showCallkitIncoming(String uuid, Map<String, dynamic> data) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: data["name"],
    appName: 'Space Texting',
    handle: '0123456789',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    extra: <String, dynamic>{...data},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
      textColor: '#ffffff',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51QBJgjJ3CcccrszuT9iSEmrXbBpd25voJRxasczpLfvJXiXb4fRsASzdMvkWQEJW0g8q3aNdZYDVmpCPxIqOgyPE00O8J0bHVe";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final Uuid _uuid;
  String? _currentUuid;

  late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _uuid = const Uuid();
    initFirebase();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    checkAndNavigationCallingPage();
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[calls.length - 1]['id'];
        return calls[calls.length - 1];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      print("Current Call ${currentCall}");
      if (currentCall["accepted"]) {
        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(currentCall["extra"]["callId"])
            .get()
            .then((value) {
          if (value.exists && !value.data()!["hangUped"]) {
            if (currentCall["extra"]["callType"] == "video") {
              Get.toNamed(Routes.VIDEO_CALL, arguments: {
                "callId": currentCall["extra"]["callId"],
                'isCaller': false,
                "receiverId": currentCall["extra"]["receiverId"]
              });
            } else if (currentCall["extra"]["callType"] == "audio") {
              Get.toNamed(Routes.VOICE_CALL, arguments: {
                "receiverId": currentCall["extra"]["receiverId"],
                'isCaller': false,
                'name': currentCall["extra"]["name"],
                'profileImage': "",
              });
            }
          }
        });
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initFirebase() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      _currentUuid = _uuid.v4();
      if (message.data["callType"] != "text") {
        showCallkitIncoming(_currentUuid!, message.data);
      }
    });
    _firebaseMessaging.getToken().then((token) {
      print('Device Token FCM: $token');
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.NAVBAR
          : AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }
}

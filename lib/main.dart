import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:get/get.dart';
import 'package:space_texting/firebase_options.dart';

import 'app/routes/app_pages.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Handling a background message: ${message.messageId}");
  yourCustomFunction();
}

void yourCustomFunction() async {
  // Custom logic for handling the call notification
  print("Custom function triggered!");

  CallKitParams callKitParams = CallKitParams(
    id: "12345678908171717",
    nameCaller: 'Test',
    appName: 'Callkit',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 0,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    duration: 30000,
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'https://i.pravatar.cc/500',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
        isShowCallID: false),
    ios: IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'generic',
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
  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
}

void handleForegroundNotification(RemoteMessage message) {
  print("Handling a foreground notification: ${message.notification?.title}");
  // Display an alert dialog or custom notification UI
  Get.snackbar(
    message.notification?.title ?? "Notification",
    message.notification?.body ?? "You have a new message",
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.black.withOpacity(0.8),
    colorText: Colors.white,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Foreground notification handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received a foreground message: ${message.data}");
    yourCustomFunction();
  });

  runApp(
    GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.NAVBAR
          : AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

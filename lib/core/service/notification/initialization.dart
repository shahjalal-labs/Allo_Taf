import 'dart:developer';
import 'dart:io';

import 'package:allo_taf/core/service/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initializeFCM() async {
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      String? apnsToken;
      int attempts = 0;
      const int maxAttempts = 10;

      do {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;
      } while (apnsToken == null && attempts < maxAttempts);

      log("APNS Token: $apnsToken");
    }

    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await AuthService.saveFCM(token);
      log('Saved FCM Token: $token');

      final readBack = AuthService.fcmToken;
      log('Read Back FCM Token: $readBack');
    } else {
      log('FCM token is null');
    }
  } catch (e) {
    log('FCM initialization error: $e');
  }
}

import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles push notification initialization and display.
class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    // 🔹 Request notification permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      developer.log("❌ Notification permissions not granted.");
      return;
    }

    developer.log("✅ User granted notification permissions");

    // 🔹 Set iOS foreground presentation behavior
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 iOS: get APNs token
    if (Platform.isIOS) {
      String? apnsToken;
      int attempts = 0;
      const int maxAttempts = 10;

      do {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;
      } while (apnsToken == null && attempts < maxAttempts);

      if (apnsToken == null) {
        developer.log(
          "⚠️ Failed to get APNs token after $maxAttempts attempts.",
        );
        return;
      }

      developer.log("📱 APNs Token: $apnsToken");
    }

    // 🔹 Get FCM token
    final token = await _firebaseMessaging.getToken();
    developer.log("🔥 FCM Token: $token");

    // 🔹 Initialize local notifications
    await _initializeLocalNotifications();

    // 🔹 Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log(
        "📥 Foreground message received: ${message.notification?.title ?? 'Data message'}",
      );

      if (message.notification != null) {
        _showNotification(message);
      } else {
        _handleDataOnlyMessage(message);
      }
    });

    // 🔹 When app is opened from background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log("🔁 App opened from background notification");
      _navigateToScreen(message);
    });

    // 🔹 When app is opened from terminated state
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      developer.log("🚀 App opened from terminated notification");
      _navigateToScreen(initialMessage);
    }
  }

  /// Setup local notification plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        developer.log("📲 Local notification clicked");
      },
    );
  }

  /// Display a local notification
  Future<void> _showNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    final payload = jsonEncode({
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
      'time':
          message.sentTime?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'data': message.data,
    });

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications', // channel name
      channelDescription: 'Used for important notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.messageId.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message',
      notificationDetails,
      payload: payload,
    );
  }

  /// Handle data-only messages
  void _handleDataOnlyMessage(RemoteMessage message) {
    developer.log("🧾 Processing data-only message: ${message.data}");
  }

  /// Navigate when user taps notification
  void _navigateToScreen(RemoteMessage message) {
    final title = message.notification?.title ?? 'No Title';
    final body = message.notification?.body ?? 'No Body';
    final sentTime =
        message.sentTime?.toIso8601String() ?? DateTime.now().toIso8601String();

    developer.log(
      "🔍 Navigate to screen with title: $title, body: $body, time: $sentTime",
    );

    // Example navigation logic:
    // Get.to(() => NotificationPage(title: title, body: body, time: sentTime));
  }
}

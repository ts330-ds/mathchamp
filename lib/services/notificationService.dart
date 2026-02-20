import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOP-LEVEL background handler
// Must be a top-level function (not inside a class).
// Called when the app is in the BACKGROUND or TERMINATED state.
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // When the app is terminated, Flutter engine is not running yet,
  // so we only show the local notification here.
  await NotificationService._showLocalNotification(message);
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Channel (Android O+)
// ─────────────────────────────────────────────────────────────────────────────
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'mathchamp_high_importance', // id
  'MathChamp Notifications', // name
  description: 'Notifications from MathChamp app',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);

// ─────────────────────────────────────────────────────────────────────────────
// NotificationService
// ─────────────────────────────────────────────────────────────────────────────
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Called from main() before runApp()
  Future<void> initialize() async {
    // 1. Set up local notifications plugin
    await _initLocalNotifications();

    // 2. Create the Android notification channel
    await _createAndroidChannel();

    // 3. Request permission from the OS
    await _requestPermission();

    // 4. Register the top-level background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 5. Handle all three FCM scenarios
    _handleForegroundMessages();
    _handleNotificationOpenedApp();
    await _handleTerminatedAppLaunch();

    // 6. Log the FCM token (useful during development)
    final token = await _fcm.getToken();
    debugPrint('📲 FCM Token: $token');

    // Refresh token listener
    _fcm.onTokenRefresh.listen((newToken) {
      debugPrint('📲 FCM Token refreshed: $newToken');
      // TODO: send updated token to your server if needed
    });
  }

  // ── 1. Init flutter_local_notifications ──────────────────────────────────
  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // we request manually via FCM below
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );
  }

  // ── 2. Create Android notification channel ────────────────────────────────
  Future<void> _createAndroidChannel() async {
    if (!Platform.isAndroid) return;
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  // ── 3. Request permission ─────────────────────────────────────────────────
  Future<void> _requestPermission() async {
    // iOS / macOS
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint(
        '🔔 Notification permission: ${settings.authorizationStatus}');

    // Android 13+ (API 33) — flutter_local_notifications handles this
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  // ── 4a. FOREGROUND messages ───────────────────────────────────────────────
  // FCM does NOT show a heads-up notification when the app is in foreground.
  // We show one manually using flutter_local_notifications.
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📬 Foreground message: ${message.messageId}');
      _showLocalNotification(message);
    });
  }

  // ── 4b. BACKGROUND → app opened via notification tap ─────────────────────
  void _handleNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔓 Notification tapped (background): ${message.messageId}');
      _handleNavigation(message.data);
    });
  }

  // ── 4c. TERMINATED → app launched via notification tap ───────────────────
  Future<void> _handleTerminatedAppLaunch() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          '🚀 App launched from notification: ${initialMessage.messageId}');
      // Small delay so the widget tree is ready before navigation
      await Future.delayed(const Duration(milliseconds: 500));
      _handleNavigation(initialMessage.data);
    }
  }

  // ── Show a local notification ─────────────────────────────────────────────
  // Static so it can be called from the top-level background handler too.
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final plugin = FlutterLocalNotificationsPlugin();

    // Re-init for background isolate (safe to call multiple times)
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(
        notification.body ?? '',
        contentTitle: notification.title,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await plugin.show(
      message.hashCode, // unique id
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  // ── Navigation based on FCM data payload ─────────────────────────────────
  void _handleNavigation(Map<String, dynamic> data) {
    // Add your custom routing logic here.
    // Example: if data contains a 'screen' key, navigate to that screen.
    // You can use a global navigator key or any navigation solution.
    final screen = data['screen'] as String?;
    debugPrint('📍 Navigate to screen: $screen');
    // TODO: use your router to navigate, e.g.:
    // navigatorKey.currentState?.pushNamed(screen ?? '/home');
  }

  // ── Local notification tap callback ──────────────────────────────────────
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Local notification tapped: ${response.payload}');
    // TODO: parse payload and navigate if needed
  }

  /// Get the current FCM token (call this to send to your backend)
  Future<String?> getToken() => _fcm.getToken();

  /// Subscribe to a topic (e.g. "all_users", "math_tips")
  Future<void> subscribeToTopic(String topic) =>
      _fcm.subscribeToTopic(topic);

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) =>
      _fcm.unsubscribeFromTopic(topic);
}

// ─────────────────────────────────────────────────────────────────────────────
// Top-level background tap handler (required by flutter_local_notifications)
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
void _onBackgroundNotificationTapped(NotificationResponse response) {
  debugPrint('👆 Background local notification tapped: ${response.payload}');
  // TODO: navigate if needed
}

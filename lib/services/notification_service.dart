import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidInitializationSettings _initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  static const InitializationSettings _initializationSettings =
      InitializationSettings(android: _initializationSettingsAndroid);

  static const AndroidNotificationDetails
      _exchangeRequestAndroidNotificationDetails = AndroidNotificationDetails(
    'Exchange Request',
    'Exchange Request Notification',
    channelDescription:
        'Notify you when you have a new exchange request for supplying',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
  );
  static const NotificationDetails _exchangeRequestNotificationDetails =
      NotificationDetails(android: _exchangeRequestAndroidNotificationDetails);

  Future<void> initLocalNotification() async {
    await _localNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload: $payload');
        }
      },
    );
  }

  Future<void> showNotification(
      {required String title, required String body}) async {
    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      _exchangeRequestNotificationDetails,
      payload: 'item x',
    );
  }
}

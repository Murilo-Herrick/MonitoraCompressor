part of 'noti_libs.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INITIALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return; // previne que o service seja iniciado 2 vezes

    const initSettingsAndroid =
        AndroidInitializationSettings('compressor');

    // config de inicializacao
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    await notificationPlugin.initialize(initSettings);
  }

  // NOTIFICATIONS DETAIL SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'compressor_channelId',
            'Notificação do Compressor',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'compressor',
            channelDescription: 'Canal de notificação do compressor'));
  }

  // SHOW NOTIFICATION
  Future<void> ShowNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';


class NotiService{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse){
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init()async{
  

    const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = 
      DarwinInitializationSettings();

    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
        defaultActionName: 'Open notification');
  final WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
          appName: 'Flutter Local Notifications Example',
          appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
          // Search online for GUID generators to make your own
          guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
      windows: initializationSettingsWindows);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }


  static Future showNotification({
    required String title,
    required String body,
    required String payload
  })async{
    const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'Lazyless',
        'your channel name',
        channelDescription: 'your channel discription',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher'
      );
    const NotificationDetails notificationDetails = 
      NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
      .show(1, title, body, notificationDetails, payload: payload);
  }


}
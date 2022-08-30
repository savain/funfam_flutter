import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fun_fam/router/routes.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_options.dart';

Future<void> initNotification() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  // iOS foreground에서 heads up display 표시를 위해 alert, sound true로 설정
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // Android용 새 Notification Channel
  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'funfam_noti_channel', // 임의의 id
    'FunFam 알림', // 설정에 보일 채널명
    importance: Importance.max,
  );

  // Notification Channel을 디바이스에 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  // FlutterLocalNotificationsPlugin 초기화. 이 부분은 notification icon 부분에서 다시 다룬다.
  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings()),
      onSelectNotification: (String? payload) async {});

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("Got message in foreground!");
    log('Message data: ${message.data}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'funfam_noti_channel', // AndroidNotificationChannel()에서 생성한 ID
            'FunFam 알림', // 설정에 보일 채널명
          ),
        ),
        // 여기서는 간단하게 data 영역의 임의의 필드(ex. argument)를 사용한다.
        payload: message.data['argument'],
      );
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final state = AppState(await SharedPreferences.getInstance());
  state.checkLoggedIn();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initNotification();

  runApp(FunFamApp(appState: state));
}

class FunFamApp extends StatelessWidget {
  final AppState appState;

  const FunFamApp({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          lazy: false,
          create: (BuildContext createContext) => appState,
        ),
        Provider<FunFamRouter>(
          lazy: false,
          create: (BuildContext createContext) => FunFamRouter(appState),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router =
              Provider.of<FunFamRouter>(context, listen: false).router;
          return MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'FunFam',
              theme: ThemeData(
                  pageTransitionsTheme: const PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  }),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  primaryColor: const Color(0xffffffff),
                  fontFamily: 'SpoqaHanSansNeo',
                  appBarTheme: const AppBarTheme(color: Colors.white),
                  scaffoldBackgroundColor: Colors.white,
                  textTheme: const TextTheme(
                    headline1:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                    headline2: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    headline3: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.normal),
                    caption: TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.normal),
                  )));
        },
      ),
    );
  }
}

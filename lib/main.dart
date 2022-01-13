import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fun_fam/router/routes.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final state = AppState(await SharedPreferences.getInstance());
  state.checkLoggedIn();

  runApp(FunFamApp(appState: state));
}

class FunFamApp extends StatelessWidget {
  final AppState appState;

  const FunFamApp({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
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
          final router = Provider.of<FunFamRouter>(context, listen: false).router;
          return MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'FunFam',
              theme: ThemeData(
                  primaryColor: const Color(0xffadadad),
                  primaryColorLight: const Color(0xfffafafa),
                  primaryColorDark: const Color(0xff000000),
                  indicatorColor: const Color(0xffa2ced4),
                  highlightColor: const Color(0xffa2b3d4),

                  fontFamily: 'SpoqaHanSansNeo',

                  textTheme: const TextTheme(
                    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    headline2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                    headline3: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                    caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                  )
              )
          );
        },
      ),
    );
  }
}

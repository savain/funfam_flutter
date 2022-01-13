import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fun_fam/constants.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:fun_fam/ui/entry.dart';
import 'package:fun_fam/ui/home.dart';
import 'package:fun_fam/ui/loading_overlay.dart';
import 'package:fun_fam/ui/login.dart';
import 'package:go_router/go_router.dart';

class FunFamRouter {
  final AppState appState;

  FunFamRouter(this.appState);

  late final router = GoRouter(
      refreshListenable: appState,
      debugLogDiagnostics: true,
      urlPathStrategy: UrlPathStrategy.path,
      routes: [
        GoRoute(
          path: '/',
          redirect: (state) =>
              state.namedLocation(routeEntryName),
        ),
        GoRoute(
          name: routeEntryName,
          path: '/entry',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const Entry(),
          ),
        ),
        GoRoute(
          name: routeLoginName,
          path: '/login',
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const Login(),
          ),
        ),
        GoRoute(
          name: routeHomeName,
          path: '/home',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
      ],

      redirect: (state) {
        final entryLoc = state.namedLocation(routeEntryName);
        final loginLoc = state.namedLocation(routeLoginName);
        final launching = state.subloc == entryLoc;
        final loggingIn = state.subloc == loginLoc;
        final loggedIn = appState.loggedIn;
        final homeLoc = state.namedLocation(routeHomeName);

        log("launch status ${appState.isLaunched}");
        log("login status ${appState.loggedIn}");
        if (!appState.isLaunched && !launching) return entryLoc;
        if (appState.isLaunched && !loggedIn && !loggingIn) return loginLoc;
        if (appState.isLaunched && loggedIn && (loggingIn || launching)) return homeLoc;

        return null;
      }
  );
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
      key: key,
      transitionsBuilder: (c, animation, a2, child) => FadeTransition(
        opacity: animation.drive(_curveTween),
        child: child,
      ),
      child: child);

  static final _curveTween = CurveTween(curve: Curves.easeIn);
}

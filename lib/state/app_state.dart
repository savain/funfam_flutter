import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AppState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _isLaunched = false;
  bool _loggedIn = false;

  AppState(this.prefs) {
    log("${prefs.getBool(prefLoggedInKey)}");
    loggedIn = prefs.getBool(prefLoggedInKey) ?? false;
  }

  bool get isLaunched => _isLaunched;
  set isLaunched(bool value) {
    _isLaunched = value;
    notifyListeners();
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool(prefLoggedInKey, value);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool(prefLoggedInKey) ?? false;
  }
}
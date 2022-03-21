import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AppState extends ChangeNotifier {
  final SharedPreferences prefs;

  bool _isLaunched = false;
  bool _loggedIn = false;

  String? _email;
  String? _nickname;
  String? _avatarRef;
  final Map<String, String> _userAvatarRefs = {};

  AppState(this.prefs) {
    loggedIn = prefs.getBool(prefLoggedInKey) ?? false;
    email = prefs.getString(prefEmailKey);
    nickname = prefs.getString(prefNicknameKey);
    avatarRef = prefs.getString(prefAvatarRefKey);

    saveDeviceToken();
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

  String? get email => _email;
  set email(String? value) {
    if (value != null) {
      _email = value;
      prefs.setString(prefEmailKey, value);
      notifyListeners();
    }
  }

  String? get nickname => _nickname;
  set nickname(String? value) {
    if (value != null) {
      _nickname = value;
      prefs.setString(prefNicknameKey, value);
      notifyListeners();
    }
  }

  String? get avatarRef => _avatarRef;
  set avatarRef(String? value) {
    if (value != null) {
      _avatarRef = value;
      prefs.setString(prefAvatarRefKey, value);
      notifyListeners();
    }
  }

  String? getUserAvatarRef(String uid) => _userAvatarRefs[uid];
  setUserAvatarRef(String? uid, String url) {
    if (uid != null) {
      _userAvatarRefs[uid] = url;
    }
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool(prefLoggedInKey) ?? false;
  }

  void saveDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String? token) async {
    if (loggedIn && token != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }
  }
}

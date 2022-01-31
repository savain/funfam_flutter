// shared preference
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

const String prefLoggedInKey = 'PrefLoggedIn';
const String prefEmailKey = 'PrefEmail';
const String prefNicknameKey = 'PrefNickname';
const String prefAvatarRefKey = 'PrefAvatarRef';

// routing
const String routeEntryName = 'entry';
const String routeLoginName = 'login';
const String routeNicknameName = 'nickname';
const String routeHomeName = 'home';

const String routeScheduleCreate = 'scheduleCreate';
const String routeScheduleDetail = 'scheduleDetail';

DateFormat scheduleDateFormat = DateFormat("yyyy/MM/dd");

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[300],
      textColor: Colors.black,
      fontSize: 16.0);
}

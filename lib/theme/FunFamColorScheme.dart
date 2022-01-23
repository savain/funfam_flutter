import 'package:flutter/material.dart';

extension FunFamColorScheme on ColorScheme {
  Color get black => const Color(0xff000000);
  Color get darkGrey => const Color(0xffadadad);
  Color get lightGrey1 => const Color(0xfffafafa);
  Color get lightGrey2 => const Color(0xffcacaca);
  Color get blue => const Color(0xffa2b3d4);
  Color get green => const Color(0xffa2ced4);

  // Color get warning => this.brightness == Brightness.light
  //     ? const Color(0xFF28a745)
  //     : const Color(0xFF28a745);
}

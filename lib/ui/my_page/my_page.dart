import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fun_fam/component/avatar_button.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AvatarButton(
          avatarRef: Provider.of<AppState>(context, listen: false).avatarRef,
          size: 85,
          onImageSelected: (File selectedImage) {},
        ),
        Container(
          height: 40,
          width: 40,
          color: Colors.black,
        )
      ],
    );
  }
}

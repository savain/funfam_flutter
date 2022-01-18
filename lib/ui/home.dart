import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fun_fam/component/avatar_button.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: AvatarButton(
                  size: 85,
                  onImageSelected: (File selectedImage) {},
                  avatarRef:
                      Provider.of<AppState>(context, listen: false).avatarRef,
                ),
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.all(Radius.circular(45))),
              )
            ],
          )
        ],
      )),
    );
  }
}

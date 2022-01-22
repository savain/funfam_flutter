import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fun_fam/component/avatar_button.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("EEEEE, DD MMMM, yyyy", 'en_US')
                    .format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              Text(
                "Welcome back,\n${Provider.of<AppState>(context, listen: false).nickname}",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
            ],
          ),
          Container(
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
      ),
    );
  }
}

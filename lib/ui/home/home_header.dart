import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/component/user_avartar.dart';
import 'package:fun_fam/model/FunFamUser.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _myInfo =
        userRef(FirebaseAuth.instance.currentUser!.uid.toString()).snapshots();

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
                    .copyWith(color: Theme.of(context).colorScheme.black),
              ),
              Text(
                "Welcome back,\n${Provider.of<AppState>(context, listen: false).nickname}",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).colorScheme.black),
              ),
            ],
          ),
          Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _myInfo,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                return UserAvatar(
                  size: 85,
                  avatarRef: snapshot.data?["avatarRef"],
                );
              },
            ),
            width: 85,
            height: 85,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.lightGrey1,
                borderRadius: const BorderRadius.all(Radius.circular(45))),
          )
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            Provider.of<AppState>(context, listen: false).isLaunched = true;
          });
        }
      });

    getUserInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 29,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Lottie.asset('assets/launch.json',
                        width: 150,
                        height: 100,
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        }
                    )
                  ],
                )
            ),
            Expanded(
              flex: 35,
              child: Container(
                color: Colors.white,
              ),)
          ],
        ),
      )
    );
  }

  void getUserInfo() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await users.get();
    snapshot.docs.forEach((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;

      log("Full Name: ${data['nickname']}");
    });
    // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

  }
}
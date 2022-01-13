import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'loading_overlay.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

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
                    SvgPicture.asset(
                      "assets/logo.svg",
                      width: 150,
                      height: 100,
                    )
                  ],
                )
            ),
            Expanded(
              flex: 35,
              child: Container(
                padding: const EdgeInsets.only(bottom: 50, right: 40, left: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("구글 아이디로 로그인 할 수 있어요"),
                    const SizedBox(height: 10,),
                    OutlinedButton.icon(
                        onPressed: () {
                          overlay.during(signInWithGoogle());
                        },
                        style: ButtonStyle(
                          minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(50)),
                          foregroundColor:
                          MaterialStateProperty.all(Colors.black),
                          textStyle:
                          MaterialStateProperty.all(Theme.of(context).textTheme.headline3),
                        ),
                        icon: Image.asset("assets/ic_google.png", width: 25, height: 25,),
                        label: const Text("구글로 시작하기")
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    log("$googleUser");
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Provider.of<AppState>(context, listen: false).email = FirebaseAuth.instance.currentUser?.email;

    // get nickname if exist
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(FirebaseAuth.instance.currentUser?.uid).get();

    if (snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Provider.of<AppState>(context, listen: false).nickname = data["nickname"];
    }

    // change login status
    Provider.of<AppState>(context, listen: false).loggedIn = true;
  }
}
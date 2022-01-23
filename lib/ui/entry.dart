import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/component/loading_overlay.dart';
import 'package:fun_fam/constants.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> with TickerProviderStateMixin {
  late final AnimationController _controller;

  String? userEmail;
  String? nickname;
  String? avatarRef;
  bool isLoggedIn = false;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      Lottie.asset('assets/launch.json',
                          height: 100,
                          controller: _controller, onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      })
                    ],
                  )),
              Expanded(
                flex: 35,
                child: Container(
                    padding:
                        const EdgeInsets.only(bottom: 50, right: 40, left: 40),
                    child: AnimatedOpacity(
                      opacity: (Provider.of<AppState>(context, listen: false)
                                  .isLaunched &&
                              !isLoggedIn)
                          ? 1.0
                          : 0.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("구글 아이디로 로그인 할 수 있어요"),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlinedButton.icon(
                              onPressed: () async {
                                await overlay.during(signInWithGoogle());
                                _routing();
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size.fromHeight(50)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                textStyle: MaterialStateProperty.all(
                                    Theme.of(context).textTheme.headline3),
                              ),
                              icon: Image.asset(
                                "assets/ic_google.png",
                                width: 25,
                                height: 25,
                              ),
                              label: const Text("구글로 시작하기")),
                        ],
                      ),
                      duration: Duration(milliseconds: 300),
                    )),
              )
            ],
          ),
        ));
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // get nickname if exist
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot =
        await users.doc(FirebaseAuth.instance.currentUser?.uid).get();

    String? nickname;
    String? avatarRef;
    if (snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      nickname = data["nickname"];
      avatarRef = data["avatarRef"];
    }

    setState(() {
      userEmail = FirebaseAuth.instance.currentUser?.email;
      isLoggedIn = true;
      this.nickname = nickname;
      this.avatarRef = avatarRef;
    });
  }

  _routing() {
    Provider.of<AppState>(context, listen: false).loggedIn = true;
    Provider.of<AppState>(context, listen: false).email = userEmail;
    Provider.of<AppState>(context, listen: false).nickname = nickname;
    Provider.of<AppState>(context, listen: false).avatarRef = avatarRef;

    if (nickname == null) {
      GoRouter.of(context).pushNamed(routeNicknameName);
    }
  }
}

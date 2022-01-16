import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/model/FunFamUser.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'loading_overlay.dart';


class Nickname extends StatefulWidget {
  const Nickname({Key? key}) : super(key: key);

  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  final formKey = GlobalKey<FormState>();

  late FocusNode nicknameFocus = FocusNode();
  String hintText = '닉네임을 입력해 주세요';
  String nickname = '';

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  File? _croppedImage;

  bool _isStartButtonEnable = false;

  @override
  void initState() {
    super.initState();
    nicknameFocus.addListener(() {
      hintText = '';
      setState((){});
    });
  }

  @override
  void dispose() {
    nicknameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(child: Container()),
                Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
                            ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                              return getAvatarWidget();
                            })
                            : getAvatarWidget(),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          await overlay.during(_pickAvatarImage());
                          if (_pickedImage != null) {
                            overlay.during(_cropAvatarImage());
                          }
                        },
                      ),
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: const BorderRadius.all(Radius.circular(45))
                      ),
                    )
                ),
                Center(
                  child: IntrinsicWidth(
                    child: TextFormField(
                        focusNode: nicknameFocus,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white),
                        onChanged: (val) {
                          setState(() {
                            nickname = val;
                            _isStartButtonEnable = val.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: nickname.isNotEmpty
                              ? Theme.of(context).highlightColor
                              : Theme.of(context).primaryColorLight,
                          contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: Theme.of(context).textTheme.headline2!
                              .copyWith(color: Theme.of(context).primaryColor),
                        )
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                        onPressed: () {
                          _logout();
                        },
                        child: Text("다른 이메일로 로그인하기",
                          style: Theme.of(context).textTheme.caption!
                              .copyWith(color: Theme.of(context).primaryColor),)
                    ),
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          String? nickName;
                          if (_isStartButtonEnable) {
                            nickName = await overlay.during(_startFunFam());
                          }

                          Provider.of<AppState>(context, listen: false).nickname = nickName;
                        },
                        child: Text("Funfam 시작하기",
                          style: Theme.of(context).textTheme.headline2!
                              .copyWith(color:
                          _isStartButtonEnable
                              ? Colors.white
                              : Theme.of(context).primaryColor
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(
                              _isStartButtonEnable
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context).primaryColorLight),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      setState(() {
        _pickedImage = response.file;
      });
      _cropAvatarImage();
    } else {
      _showError();
    }
  }

  Future<void> _pickAvatarImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    } else {
      _showError();
    }
  }

  Future<void> _cropAvatarImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: _pickedImage!.path,
        aspectRatioPresets: [ CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '썸네일 이미지 수정',
            toolbarColor: Theme.of(context).indicatorColor,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Theme.of(context).indicatorColor,
            activeControlsWidgetColor: Theme.of(context).indicatorColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: '썸네일 이미지 수정',
        ));

    if (croppedFile != null) {
      setState(() {
        _croppedImage = croppedFile;
      });
    } else {
      _showError();
    }
  }

  void _showError() {
    Fluttertoast.showToast(
        msg: "사진 선택에 실패했습니다.\n다시 사진을 선택해주세요!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).primaryColorLight,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  Widget getAvatarWidget() {
    return _croppedImage == null
        ? Image.asset("assets/ic_anonymous.png")
        : CircleAvatar(
      radius: 45,
      backgroundImage: Image.file(_croppedImage!, fit: BoxFit.fill).image,
      backgroundColor: Colors.transparent,
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();

    Provider.of<AppState>(context, listen: false).loggedIn = false;
    Provider.of<AppState>(context, listen: false).email = null;
    Provider.of<AppState>(context, listen: false).nickname = null;
  }

  Future<String?> _startFunFam() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? avatarRef;

    if (_croppedImage != null) {
      try {
        String extension = p.extension(_croppedImage!.path);
        avatarRef = 'avatar/$uid$extension';

        await firebase_storage.FirebaseStorage.instance
            .ref(avatarRef)
            .putFile(_croppedImage!);

      } on FirebaseException catch (e) {
        avatarRef = null;

        Fluttertoast.showToast(
            msg: "사진 업로드에 실패했습니다.\n다시 시도해주세요!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColorLight,
            textColor: Colors.black,
            fontSize: 16.0
        );
        return null;
      }
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users').withConverter<FunFamUser>(
      fromFirestore: (snapshot, _) => FunFamUser.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );

    String email = Provider.of<AppState>(context, listen: false).email ?? "";

    await users
        .doc(uid)
        .set(
        FunFamUser(
            uid: uid,
            email: email,
            nickname: nickname,
            avatarRef: avatarRef
        ));

    Provider.of<AppState>(context, listen: false).avatarRef = avatarRef;

    return nickname;
  }
}
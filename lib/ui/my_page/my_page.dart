import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/component/avatar_button.dart';
import 'package:fun_fam/component/loading_overlay.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ValueNotifier<String?> _avatarRef = ValueNotifier(null);

  @override
  void initState() {
    _avatarRef.value = Provider.of<AppState>(context, listen: false).avatarRef;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<String?>(
            valueListenable: _avatarRef,
            builder: (context, value, _) {
              return AvatarButton(
                  avatarRef: value,
                  size: 85,
                  onImageSelected: (File selectedImage) {
                    overlay.during(_updateAvatar(selectedImage));
                  });
            }),
        Container(
          height: 40,
          width: 40,
          color: Colors.black,
        )
      ],
    );
  }

  Future<void> _updateAvatar(File selectedImage) async {
    try {
      var uuid = const Uuid();
      String extension = p.extension(selectedImage.path);
      String avatarRef = 'avatar/${uuid.v1()}$extension';

      await FirebaseStorage.instance.ref(avatarRef).putFile(selectedImage);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"avatarRef": avatarRef});

      _avatarRef.value = avatarRef;
      Provider.of<AppState>(context, listen: false).avatarRef = avatarRef;

      showToast("사진이 업데이트 되었습니다!");
    } on FirebaseException catch (e) {
      showToast("사진이 업데이트에 실패하였습니다. 영수에게 문의하세요 ㅠ");
    }
  }
}

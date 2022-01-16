import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) ?
                    FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          return getAvatarWidget();
                        }
                    ) : getAvatarWidget(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      _pickAvatarImage();
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
                    onChanged: (val) {
                      setState(() {
                        nickname = val;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: nickname.isNotEmpty ? Theme.of(context).highlightColor : Theme.of(context).primaryColorLight,
                      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: InputBorder.none,
                      hintText: hintText,
                    )
                ),
              ),
            )
          ],
        ),
      ),
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

  void _pickAvatarImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
      _cropAvatarImage();
    } else {
      _showError();
    }
  }

  void _cropAvatarImage() async {
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
}
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'loading_overlay.dart';

class AvatarButton extends StatefulWidget {
  final double size;
  final Function(File selectedImage) onImageSelected;
  final String? avatarRef;

  const AvatarButton(
      {Key? key,
      required this.size,
      required this.onImageSelected,
      this.avatarRef})
      : super(key: key);

  @override
  _AvatarButtonState createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  File? _croppedImage;
  String? _avatarUrl;

  late Future imageUrlFuture;

  @override
  void initState() {
    super.initState();

    imageUrlFuture = _getAvatarImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return IconButton(
      padding: EdgeInsets.zero,
      icon: (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          ? FutureBuilder<void>(
              future: _retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return (widget.avatarRef != null)
                    ? FutureBuilder<void>(
                        future: imageUrlFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          return _getAvatarWidget();
                        })
                    : _getAvatarWidget();
              })
          : (widget.avatarRef != null)
              ? FutureBuilder<void>(
                  future: imageUrlFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return _getAvatarWidget();
                  })
              : _getAvatarWidget(),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () async {
        await overlay.during(_pickAvatarImage());
        if (_pickedImage != null) {
          overlay.during(_cropAvatarImage());
        }
      },
    );
  }

  Future<void> _retrieveLostData() async {
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

  Future<void> _getAvatarImageUrl() async {
    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref(widget.avatarRef!)
        .getDownloadURL();

    setState(() {
      _avatarUrl = downloadUrl;
    });
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
        aspectRatioPresets: [CropAspectRatioPreset.square],
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
        widget.onImageSelected(croppedFile);
      });
    } else {
      _showError();
    }
  }

  Widget _getAvatarWidget() {
    if (_avatarUrl != null) {
      return CachedNetworkImage(
          imageUrl: _avatarUrl!,
          imageBuilder: (context, imageProvider) => Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
          placeholder: (context, url) => Image.asset("assets/ic_anonymous.png"),
          errorWidget: (context, url, error) =>
              Image.asset("assets/ic_anonymous.png"));
    } else {
      return (_croppedImage != null)
          ? CircleAvatar(
              radius: widget.size / 2,
              backgroundImage:
                  Image.file(_croppedImage!, fit: BoxFit.fill).image,
              backgroundColor: Colors.transparent)
          : Image.asset("assets/ic_anonymous.png");
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
        fontSize: 16.0);
  }
}

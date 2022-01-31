import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';

class UserAvatar extends StatefulWidget {
  final String uid;
  final double size;

  const UserAvatar({Key? key, required this.uid, required this.size})
      : super(key: key);

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late Future<String> _getAvatarUrl;

  @override
  void initState() {
    _getAvatarUrl = getAvatarUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final DrawableRoot svgRoot = SvgPicture.asset("assets/ic_empty.svg");

    return FutureBuilder<String>(
        future: _getAvatarUrl,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return CircleAvatar(
            radius: widget.size / 2,
            backgroundImage: (snapshot.hasData == false || snapshot.hasError)
                ? const AssetImage("assets/ic_empty.png")
                : CachedNetworkImageProvider(snapshot.data!) as ImageProvider,
            backgroundColor: Theme.of(context).colorScheme.lightGrey1,
          );
        });
  }

  Future<String> getAvatarUrl() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String avatarRef = data["avatarRef"];

    String downloadUrl =
        await FirebaseStorage.instance.ref(avatarRef).getDownloadURL();
    return downloadUrl;
  }
}

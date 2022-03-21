import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class UserAvatar extends StatefulWidget {
  final String? avatarRef;
  final String? uid;
  final double size;

  const UserAvatar({Key? key, required this.size, this.uid, this.avatarRef})
      : super(key: key);

  @override
  UserAvatarState createState() => UserAvatarState();
}

class UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _getAvatarUrl(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return CircleAvatar(
            radius: widget.size / 2,
            backgroundImage: (snapshot.hasData == false ||
                    snapshot.hasError ||
                    snapshot.data == null)
                ? const AssetImage("assets/ic_empty.png")
                : CachedNetworkImageProvider(snapshot.data!) as ImageProvider,
            backgroundColor: Theme.of(context).colorScheme.lightGrey1,
          );
        });
  }

  Future<String?> _getAvatarUrl() async {
    String? avatarRef;
    if (widget.avatarRef != null) {
      avatarRef = widget.avatarRef!;
    } else if (widget.uid != null) {
      // check stored download url
      String? downloadUrl = Provider.of<AppState>(context, listen: false)
          .getUserAvatarRef(widget.uid!);
      if (downloadUrl != null) {
        return downloadUrl;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      avatarRef = data["avatarRef"];
    }

    if (avatarRef != null) {
      String downloadUrl =
          await FirebaseStorage.instance.ref(avatarRef).getDownloadURL();

      Provider.of<AppState>(context, listen: false)
          .setUserAvatarRef(widget.uid, downloadUrl);
      return downloadUrl;
    } else {
      return null;
    }
  }
}

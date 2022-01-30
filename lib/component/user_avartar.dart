import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';

class UserAvatar extends StatefulWidget {
  final String avatarRef;
  final double size;

  const UserAvatar({Key? key, required this.avatarRef, required this.size})
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
    return FutureBuilder<String>(
        future: _getAvatarUrl,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false || snapshot.hasError) {
            return Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.lightGrey1,
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.size / 2))),
            );
          } else {
            return CachedNetworkImage(
                imageUrl: snapshot.data!,
                imageBuilder: (context, imageProvider) => Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/ic_anonymous.png"));
          }
        });
  }

  Future<String> getAvatarUrl() async {
    String downloadUrl =
        await FirebaseStorage.instance.ref(widget.avatarRef).getDownloadURL();
    return downloadUrl;
  }
}

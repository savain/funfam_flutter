import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/component/user_avartar.dart';
import 'package:fun_fam/model/CommentModel.dart';

class ScheduleCommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onDeleted;

  const ScheduleCommentItem(
      {Key? key, required this.comment, required this.onDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          UserAvatar(uid: comment.uid, size: 50),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${comment.nickname} ${getTimeDiff()}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                comment.comment,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
              )
            ],
          )),
          if (comment.uid == FirebaseAuth.instance.currentUser?.uid)
            IconButton(
              onPressed: () {
                onDeleted();
              },
              iconSize: 15,
              icon: Icon(Icons.close),
            ),
        ],
      ),
    );
  }

  String getTimeDiff() {
    DateTime now = DateTime.now();
    DateTime created = comment.createdDate.toDate();
    if (created.year == now.year) {
      if (created.month == now.month) {
        if (created.day == now.day) {
          if (created.hour == now.hour) {
            if (now.minute - created.minute < 10) {
              return "방금 전";
            } else {
              return "${now.minute - created.minute}분 전";
            }
          } else {
            return "${now.hour - created.hour}시간 전";
          }
        } else {
          return "${now.day - created.day}일 전";
        }
      } else {
        return "${now.month - created.month}달 전";
      }
    } else {
      return "${now.year - created.year}년 전";
    }
  }
}

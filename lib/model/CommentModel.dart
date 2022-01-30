import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentModel {
  CommentModel(
      {required this.uid,
      required this.nickname,
      required this.comment,
      required this.createdDate});

  CommentModel.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          nickname: json['nickname']! as String,
          comment: json['comment']! as String,
          createdDate: json['createdDate']! as Timestamp,
        );

  final String uid;
  final String nickname;
  final String comment;
  final Timestamp createdDate;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'comment': comment,
      'createdDate': createdDate,
    };
  }
}

CollectionReference scheduleCommentRef(DateTime startDate) {
  DateFormat format = DateFormat("yyyyMMdd");

  return FirebaseFirestore.instance
      .collection("comments")
      .doc("schedule")
      .collection(format.format(startDate))
      .withConverter<CommentModel>(
        fromFirestore: (snapshot, _) => CommentModel.fromJson(snapshot.data()!),
        toFirestore: (comment, _) => comment.toJson(),
      );
}

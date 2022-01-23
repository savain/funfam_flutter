import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  ScheduleModel(
      {required this.uid,
      required this.nickname,
      required this.startDate,
      required this.endDate,
      required this.title,
      required this.schedule,
      required this.createdDate});

  ScheduleModel.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          nickname: json['nickname']! as String,
          startDate: json['startDate']! as Timestamp,
          endDate: json['endDate']! as Timestamp,
          title: json['title']! as String,
          schedule: json['schedule']! as String,
          createdDate: json['createdDate']! as Timestamp,
        );

  final String uid;
  final String nickname;
  final Timestamp startDate;
  final Timestamp endDate;
  final String title;
  final String schedule;
  final Timestamp createdDate;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'startDate': startDate,
      'endDate': endDate,
      'title': title,
      'schedule': schedule,
      'createdDate': createdDate,
    };
  }
}

CollectionReference get scheduleRef => FirebaseFirestore.instance
    .collection("schedules")
    .withConverter<ScheduleModel>(
      fromFirestore: (snapshot, _) => ScheduleModel.fromJson(snapshot.data()!),
      toFirestore: (schedule, _) => schedule.toJson(),
    );

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fun_fam/constants.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ScheduleDetail extends StatefulWidget {
  final String date;
  const ScheduleDetail({Key? key, required this.date}) : super(key: key);

  @override
  _ScheduleDetailState createState() => _ScheduleDetailState();
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  late DateTime _scheduleDate;

  @override
  void initState() {
    initializeDateFormatting();
    _scheduleDate = scheduleDateFormat.parse(widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy년 MM월 dd일 EEEEE", "ko");
    Query<Object?> schedules = scheduleRef
        .where("startDate",
            isGreaterThan: Timestamp.fromDate(DateTime(
                _scheduleDate.year, _scheduleDate.month, _scheduleDate.day, 0)))
        .where("startDate",
            isLessThan: Timestamp.fromDate(DateTime(_scheduleDate.year,
                _scheduleDate.month, _scheduleDate.day + 1, 0)));

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: SvgPicture.asset("assets/ic_back.svg"),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            format.format(_scheduleDate),
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black),
          ),
          actions: [Image.asset("assets/ic_noti.png")],
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: schedules.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitChasingDots(
                      color: Theme.of(context).colorScheme.green, size: 50.0),
                );
              }

              log("${snapshot.data!.docs.length}");

              (snapshot.data!.docs).forEach((element) {
                log("${element.data()}");
              });

              return ListView(
                children: snapshot.data!.docs
                    .map(
                      (snapshot) => Row(children: [
                        // UserAvatar(avatarRef: avatarRef, size: 10),
                        Text((snapshot.data() as ScheduleModel).title)
                      ]),
                    )
                    .toList(),
              );
            }));
  }
}

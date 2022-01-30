import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fun_fam/constants.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/scehdule/detail/schedule_list_item.dart';
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
  final ScrollController _controller = ScrollController();

  late DateTime _scheduleDate;
  String? _reply;
  bool _showReplay = false;

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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                      future: schedules.get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SpinKitChasingDots(
                                color: Theme.of(context).colorScheme.green,
                                size: 50.0),
                          );
                        }

                        return ListView(
                            physics: const ClampingScrollPhysics(),
                            controller: _controller,
                            children: [
                              snapshot.data!.docs
                                  .map((docSnapshot) =>
                                      (docSnapshot.data() as ScheduleModel))
                                  .map((schedule) =>
                                      ScheduleListItem(schedule: schedule))
                                  .toList(),
                              [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          _scrollDown();
                                          setState(() {
                                            _showReplay = true;
                                          });
                                        },
                                        icon: Text(
                                          "댓글달기",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.black),
                                        ),
                                        label: SvgPicture.asset(
                                          "assets/ic_reply.svg",
                                          height: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        icon: Text(
                                          "공유하기",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.black),
                                        ),
                                        label: SvgPicture.asset(
                                          "assets/ic_share.svg",
                                          height: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 200,
                                )
                              ],
                              // 댓글 list
                            ].expand((widget) => widget).toList());
                      })),
              if (_showReplay)
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(200)
                            ],
                            onChanged: (reply) {
                              setState(() {
                                _reply = reply;
                              });
                            },
                            onFieldSubmitted: (reply) {
                              log(reply);
                            },
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.black),
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.lightGrey1,
                              border: InputBorder.none,
                              hintText: "댓글을 남겨주세요",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lightGrey2),
                            )),
                      ),
                      Container(
                          height: 50,
                          width: 50,
                          color: (_reply?.isNotEmpty ?? false)
                              ? Theme.of(context).colorScheme.blue
                              : Theme.of(context).colorScheme.darkGrey,
                          child: IconButton(
                              onPressed: () {
                                log("on reply");
                              },
                              icon: SvgPicture.asset(
                                "assets/ic_enter.svg",
                                height: 20,
                              )))
                    ],
                  ),
                )
            ],
          ),
        ));
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> submitReply() async {}
}

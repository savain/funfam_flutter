import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_fam/constants.dart';
import 'package:fun_fam/model/CommentModel.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/scehdule/detail/schedule_comment_item.dart';
import 'package:fun_fam/ui/scehdule/detail/schedule_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleDetail extends StatefulWidget {
  final String date;
  const ScheduleDetail({Key? key, required this.date}) : super(key: key);

  @override
  _ScheduleDetailState createState() => _ScheduleDetailState();
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  late DateTime _scheduleDate;
  final FocusNode _replyFocus = FocusNode();
  String? _reply;
  bool _showReplay = false;

  late StreamSubscription<QuerySnapshot> _commentSub;
  final ValueNotifier<List<DocumentSnapshot>> _comments = ValueNotifier([]);

  @override
  void initState() {
    initializeDateFormatting();
    _scheduleDate = scheduleDateFormat.parse(widget.date);

    _commentSub = scheduleCommentRef(_scheduleDate)
        .orderBy("createdDate")
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((snapshot) {
        setState(() {
          if (snapshot.type == DocumentChangeType.modified) {
            int index = _comments.value
                .indexWhere((element) => element.id == snapshot.doc.id);
            _comments.value[index] = snapshot.doc;
          } else if (snapshot.type == DocumentChangeType.removed) {
            int index = _comments.value
                .indexWhere((element) => element.id == snapshot.doc.id);
            _comments.value.removeAt(index);
          } else {
            _comments.value.add(snapshot.doc);
          }
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _commentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy??? MM??? dd??? EEEEE", "ko");
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

                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          controller: _scrollController,
                          child: Column(
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
                                        setState(() {
                                          _showReplay = true;
                                          _replyFocus.requestFocus();
                                          _scrollDown();
                                        });
                                      },
                                      icon: Text(
                                        "????????????",
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
                                        "????????????",
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
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: ValueListenableBuilder<
                                          List<DocumentSnapshot>>(
                                      valueListenable: _comments,
                                      builder: (context, value, _) {
                                        return value.isNotEmpty
                                            ? Column(
                                                children: value
                                                    .map((snapshot) =>
                                                        ScheduleCommentItem(
                                                            comment: snapshot
                                                                    .data()
                                                                as CommentModel,
                                                            onDeleted: () {
                                                              _removeComment(
                                                                  snapshot.id);
                                                            }))
                                                    .toList(),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/ic_empty.png"),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    "?????? ???????????? ????????? ?????????...",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .darkGrey),
                                                  )
                                                ],
                                              );
                                      }))
                            ],
                            // ?????? list
                          ].expand((widget) => widget).toList()),
                        );
                      })),
              if (_showReplay)
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            focusNode: _replyFocus,
                            controller: _textController,
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
                              submitReply();
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
                              hintText: "????????? ???????????????",
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
                                submitReply();
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

  void _scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> submitReply() async {
    if (_reply?.isNotEmpty ?? false) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String nickname =
          Provider.of<AppState>(context, listen: false).nickname ?? "";

      scheduleCommentRef(_scheduleDate)
          .add(CommentModel(
              uid: uid,
              nickname: nickname,
              comment: _reply!,
              createdDate: Timestamp.now()))
          .then((value) => _onSuccessAddReply())
          .catchError((error) => _onFailAddReply());
    } else {
      Fluttertoast.showToast(
          msg: "?????? ????????? ??????????????????!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).colorScheme.lightGrey2,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  void _onSuccessAddReply() {
    _reply = null;
    _textController.clear();
    _scrollDown();
  }

  void _onFailAddReply() {
    Fluttertoast.showToast(
        msg: "????????? ?????? ????????? ??????????????????.\n???????????? ??????????????????. ???",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.lightGrey2,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  Future<void> _removeComment(String documentId) async {
    await scheduleCommentRef(_scheduleDate)
        .doc(documentId)
        .delete()
        .then((value) => _onSuccessRemoveReply());
  }

  void _onSuccessRemoveReply() {
    Fluttertoast.showToast(
        msg: "????????? ??????????????????.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.lightGrey2,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

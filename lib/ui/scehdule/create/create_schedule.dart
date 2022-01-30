import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_fam/component/loading_overlay.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/scehdule/create/create_schedule_content_input.dart';
import 'package:fun_fam/ui/scehdule/create/create_schedule_title_input.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'date_picker/date_picker.dart';
import 'date_picker/date_picker_activator.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({Key? key}) : super(key: key);

  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  bool _isDatePickerOpen = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool get _isDateSelected => (_startDate != null && _endDate != null);

  String? _title;
  final FocusNode _titleFocus = FocusNode();
  bool _isTitleEditComplete = false;

  String? _content;
  final FocusNode _contentFocus = FocusNode();

  bool get _showSubmitButton =>
      (_isDateSelected && _isTitleEditComplete && _content != null);

  bool get _isValid => (_isDateSelected &&
      (_title ?? "").isNotEmpty &&
      (_content ?? "").isNotEmpty);

  DateFormat format = DateFormat("yyyy년 MM월 dd일");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);
    Future.delayed(const Duration(milliseconds: 500),
        () => (_isDatePickerOpen) ? null : showDatePicker());

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
          "스케줄 작성하기",
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.black),
        ),
        actions: [Image.asset("assets/ic_noti.png")],
      ),
      body: SafeArea(
          child: ListView(
        physics: const ClampingScrollPhysics(),
        reverse: true,
        children: [
          SizedBox(
            height: 50,
            child: (_showSubmitButton)
                ? TextButton(
                    onPressed: () {
                      if (_isValid) {
                        overlay.during(submitSchedule());
                      } else {
                        String message;
                        if (!_isDateSelected) {
                          message = "스케줄 일정을 선택해주세요.";
                        } else if ((_title ?? "").isEmpty) {
                          message = "스케줄 제목을 작성해주세요.";
                        } else {
                          message = "스케줄 내용을 작성해주세요.";
                        }
                        _showError(message);
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(right: 20)),
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: MaterialStateProperty.all(_isValid
                          ? Theme.of(context).colorScheme.blue
                          : Theme.of(context).colorScheme.lightGrey2),
                      textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.headline2),
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text("작성하기"),
                    ))
                : null,
          ),
          Container(
            height: 80,
          ),
          ScheduleContentInput(
              isShow: _isDateSelected && _isTitleEditComplete,
              focus: _contentFocus,
              onChanged: (val) {
                setState(() {
                  _content = val;
                });
              }),
          ScheduleTitleInput(
              isShow: _isDateSelected,
              focus: _titleFocus,
              onChanged: (val) {
                setState(() {
                  _title = val;
                });
              },
              onEditingComplete: () {
                setState(() {
                  _isTitleEditComplete = true;
                  _contentFocus.requestFocus();
                });
              }),
          DatePickerActivator(
            startDate: _startDate,
            endDate: _endDate,
            isDateSelected: _isDateSelected,
            onPressed: () {
              showDatePicker();
            },
          )
        ],
      )),
    );
  }

  void showDatePicker() {
    setState(() {
      _isDatePickerOpen = true;
    });

    showMaterialModalBottomSheet(
      expand: false,
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ScheduleDatePicker(
        onDateSelected: (start, end) {
          setState(() {
            _startDate = start;
            _endDate = end;
            _titleFocus.requestFocus();
          });
        },
      ),
    );
  }

  void _showError(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.lightGrey2,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  Future<void> submitSchedule() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String nickname =
        Provider.of<AppState>(context, listen: false).nickname ?? "";

    await scheduleRef
        .add(ScheduleModel(
            uid: uid,
            nickname: nickname,
            startDate: Timestamp.fromDate(_startDate!),
            endDate: Timestamp.fromDate(_endDate!),
            title: _title!,
            schedule: _content!,
            createdDate: Timestamp.now()))
        .then((value) => _onSuccessAddSchedule())
        .catchError((error) => _onFailAddSchedule());
  }

  void _onSuccessAddSchedule() {
    Fluttertoast.showToast(
        msg: "새로운 스케줄을 등록했습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.lightGrey2,
        textColor: Colors.black,
        fontSize: 16.0);

    context.pop();
  }

  void _onFailAddSchedule() {
    Fluttertoast.showToast(
        msg: "새로운 스케줄을 등록에 실패했습니다.\n영수에게 문의해주세요. ㅜ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.lightGrey2,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

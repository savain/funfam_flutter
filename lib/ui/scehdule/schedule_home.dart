import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/calendar/calendar_builder.dart';
import 'package:fun_fam/ui/calendar/calendar_event.dart';
import 'package:fun_fam/ui/calendar/calendar_header.dart';
import 'package:fun_fam/ui/scehdule/schedule_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants.dart';

class ScheduleHome extends StatefulWidget {
  const ScheduleHome({Key? key}) : super(key: key);

  @override
  _ScheduleHomeState createState() => _ScheduleHomeState();
}

class _ScheduleHomeState extends State<ScheduleHome> {
  late PageController _pageController;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;

  late DateTime kFirstDay;
  late DateTime kLastDay;

  late StreamSubscription<QuerySnapshot> _scheduleSub;
  final LinkedHashMap<DateTime, List<ScheduleModel>> _schedules =
      LinkedHashMap<DateTime, List<ScheduleModel>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  final ValueNotifier<List<ScheduleModel>> _selectedSchedules =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    kFirstDay = DateTime(today.year, today.month - 3, 1);
    kLastDay = DateTime(today.year, today.month + 4, 0);

    _scheduleSub = scheduleRef
        .where("startDate", isGreaterThan: Timestamp.fromDate(kFirstDay))
        .where("startDate", isLessThan: Timestamp.fromDate(kLastDay))
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((snapshot) {
        ScheduleModel model = (snapshot.doc.data() as ScheduleModel);
        _schedules.update(
            model.startDate.toDate(), (value) => value..add(model),
            ifAbsent: () => [model]);

        updateEvents();
      });
    });
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _scheduleSub.cancel();
    super.dispose();
  }

  List<ScheduleModel> _getEventsForDay(DateTime day) {
    return (day.month == _focusedDay.value.month) ? _schedules[day] ?? [] : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(
                            width: 0.25,
                            color: Theme.of(context).colorScheme.lightGrey2)),
                    color: Theme.of(context).colorScheme.lightGrey1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 48),
                  child: Column(
                    children: [
                      ValueListenableBuilder<DateTime>(
                        valueListenable: _focusedDay,
                        builder: (context, value, _) {
                          return CalendarHeader(
                            focusedDay: value,
                            onLeftArrowTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            onRightArrowTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                          );
                        },
                      ),
                      TableCalendar<ScheduleModel>(
                          calendarBuilders: getBuilder(context),
                          calendarStyle:
                              const CalendarStyle(isTodayHighlighted: false),
                          rowHeight: 40,
                          firstDay: kFirstDay,
                          lastDay: kLastDay,
                          focusedDay: _focusedDay.value,
                          headerVisible: false,
                          daysOfWeekVisible: false,
                          eventLoader: _getEventsForDay,
                          calendarFormat: _calendarFormat,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          rangeSelectionMode: _rangeSelectionMode,
                          onCalendarCreated: (controller) =>
                              _pageController = controller,
                          onPageChanged: (focusedDay) {
                            _focusedDay.value = focusedDay;
                            updateEvents();
                          }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: ValueListenableBuilder<List<ScheduleModel>>(
                  valueListenable: _selectedSchedules,
                  builder: (context, value, _) {
                    return value.isNotEmpty
                        ? Column(
                            children: value
                                .map((event) =>
                                    ScheduleListItem(schedule: event))
                                .toList())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/ic_empty.png"),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "아직 가족들의 이번달 스케줄이 없어요",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .darkGrey),
                              )
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: TextButton(
              onPressed: () {
                context.pushNamed(routeScheduleCreate);
              },
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(40)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                )),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.lightGrey2),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.headline3),
              ),
              child: const Text("스케줄 작성하기")),
        ),
      ],
    );
  }

  void updateEvents() {
    setState(() {
      _selectedSchedules.value = _schedules.keys
          .where(
              (scheduleDate) => scheduleDate.month == _focusedDay.value.month)
          .map((scheduleDate) => _schedules[scheduleDate]?.toList() ?? [])
          .expand((schedule) => schedule)
          .toList();
    });
  }
}

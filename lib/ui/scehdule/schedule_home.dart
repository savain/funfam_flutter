import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/calendar/calendar_builder.dart';
import 'package:fun_fam/ui/calendar/calendar_event.dart';
import 'package:fun_fam/ui/calendar/calendar_header.dart';
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
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;

  late DateTime kFirstDay;
  late DateTime kLastDay;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    kFirstDay = DateTime(today.year, today.month - 3, 1);
    kLastDay = DateTime(today.year, today.month + 4, 0);

    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    // log("_getEventForDay ${day.month}:${day.day}");
    return kEvents[day] ?? [];
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
                      TableCalendar<CalendarEvent>(
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
                        onPageChanged: (focusedDay) =>
                            _focusedDay.value = focusedDay,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: 240,
                width: double.infinity,
              )
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
}

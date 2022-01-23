import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:fun_fam/ui/calendar/calendar_builder.dart';
import 'package:fun_fam/ui/calendar/calendar_header.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleDatePicker extends StatefulWidget {
  const ScheduleDatePicker({Key? key}) : super(key: key);

  @override
  _ScheduleDatePickerState createState() => _ScheduleDatePickerState();
}

class _ScheduleDatePickerState extends State<ScheduleDatePicker> {
  late PageController _pageController;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  late DateTime kFirstDay;
  late DateTime kLastDay;

  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    kFirstDay = DateTime(today.year, today.month - 3, 1);
    kLastDay = DateTime(today.year, today.month + 4, 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
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
                TableCalendar(
                  calendarBuilders: getPickerBuilder(context),
                  calendarStyle: CalendarStyle(
                      isTodayHighlighted: false,
                      rangeHighlightColor:
                          Theme.of(context).colorScheme.lightGrey2,
                      rangeHighlightScale: 2.0),
                  rowHeight: 40,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay.value,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay.value = focusedDay;
                        _rangeStart = null; // Important to clean those
                        _rangeEnd = null;
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      });
                    }
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    setState(() {
                      _selectedDay = null;
                      _focusedDay.value = focusedDay;
                      _rangeStart = start;
                      _rangeEnd = end;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    });
                  },
                  onCalendarCreated: (controller) =>
                      _pageController = controller,
                  onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.lightGrey1),
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.darkGrey),
                textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.headline2),
              ),
              child: const Text("선택완료")),
        ],
      ),
    )
        //
        //
        // Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        //
        //
        // ]),
        );
  }
}

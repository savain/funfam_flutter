// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:fun_fam/ui/home/calendar/calendar_event.dart';
// import 'package:fun_fam/util/unbounce_scroll_behavior.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import 'calendar_builder.dart';
// import 'calendar_header.dart';
//
// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({Key? key}) : super(key: key);
//
//   @override
//   _CalendarScreenState createState() => _CalendarScreenState();
// }
//
// class _CalendarScreenState extends State<CalendarScreen> {
//   late PageController _pageController;
//   late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
//   final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
//
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
//
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//
//   late DateTime kFirstDay;
//   late DateTime kLastDay;
//
//   @override
//   void initState() {
//     super.initState();
//     DateTime today = DateTime.now();
//     kFirstDay = DateTime(today.year, today.month - 3, 1);
//     kLastDay = DateTime(today.year, today.month + 4, 0);
//
//     _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
//   }
//
//   @override
//   void dispose() {
//     _focusedDay.dispose();
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//   List<CalendarEvent> _getEventsForDay(DateTime day) {
//     log("_getEventForDay ${day.month}");
//     return (day.month == _focusedDay.value.month) ? kEvents[day] ?? [] : [];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//         behavior: UnBounceScrollBehavior(),
//         child: ListView(
//           children: [
//             const SizedBox(
//               height: 40,
//             ),
//             Container(
//               color: Theme.of(context).primaryColorLight,
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(vertical: 30, horizontal: 48),
//                 child: Column(
//                   children: [
//                     ValueListenableBuilder<DateTime>(
//                       valueListenable: _focusedDay,
//                       builder: (context, value, _) {
//                         return CalendarHeader(
//                           focusedDay: value,
//                           onLeftArrowTap: () {
//                             _pageController.previousPage(
//                               duration: const Duration(milliseconds: 300),
//                               curve: Curves.easeOut,
//                             );
//                           },
//                           onRightArrowTap: () {
//                             _pageController.nextPage(
//                               duration: const Duration(milliseconds: 300),
//                               curve: Curves.easeOut,
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     TableCalendar<CalendarEvent>(
//                       calendarBuilders: getPickerBuilder(context),
//                       rowHeight: 40,
//                       calendarStyle: CalendarStyle(
//                           rangeHighlightColor:
//                           Theme.of(context).selectedRowColor,
//                           rangeHighlightScale: 2),
//                       firstDay: kFirstDay,
//                       lastDay: kLastDay,
//                       focusedDay: _focusedDay.value,
//                       headerVisible: false,
//                       daysOfWeekVisible: false,
//                       eventLoader: _getEventsForDay,
//                       selectedDayPredicate: (day) =>
//                           isSameDay(_selectedDay, day),
//                       rangeStartDay: _rangeStart,
//                       rangeEndDay: _rangeEnd,
//                       calendarFormat: _calendarFormat,
//                       rangeSelectionMode: _rangeSelectionMode,
//                       onDaySelected: (selectedDay, focusedDay) {
//                         if (!isSameDay(_selectedDay, selectedDay)) {
//                           setState(() {
//                             _selectedDay = selectedDay;
//                             _focusedDay.value = focusedDay;
//                             _rangeStart = null; // Important to clean those
//                             _rangeEnd = null;
//                             _rangeSelectionMode = RangeSelectionMode.toggledOff;
//                           });
//                         }
//                       },
//                       onRangeSelected: (start, end, focusedDay) {
//                         setState(() {
//                           _selectedDay = null;
//                           _focusedDay.value = focusedDay;
//                           _rangeStart = start;
//                           _rangeEnd = end;
//                           _rangeSelectionMode = RangeSelectionMode.toggledOn;
//                         });
//                       },
//                       onCalendarCreated: (controller) =>
//                       _pageController = controller,
//                       onPageChanged: (focusedDay) =>
//                       _focusedDay.value = focusedDay,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.red,
//               height: 240,
//               width: double.infinity,
//             )
//           ],
//         ));
//   }
// }

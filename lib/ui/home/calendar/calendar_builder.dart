import 'package:flutter/material.dart';
import 'package:fun_fam/ui/home/calendar/calendar_event.dart';
import 'package:table_calendar/table_calendar.dart';

Widget _buildCalendarDay(
    {required BuildContext context,
    required DateTime day,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.white}) {
  return Container(
    color: backgroundColor,
    child: Center(
      child: Text(day.day.toString(),
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: textColor)),
    ),
  );
}

Widget _buildRangeSelectDay(
    {required BuildContext context, required DateTime day}) {
  return Container(
    decoration: BoxDecoration(
        shape: BoxShape.circle, color: Theme.of(context).highlightColor),
    child: Center(
      child: Text(day.day.toString(),
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white)),
    ),
  );
}

Widget _buildRangeHighlight(
    {required BuildContext context, required bool isStart}) {
  return Row(
    children: [
      Expanded(
          child: Container(
        color:
            isStart ? Colors.transparent : Theme.of(context).selectedRowColor,
      )),
      Expanded(
          child: Container(
        color:
            isStart ? Theme.of(context).selectedRowColor : Colors.transparent,
      ))
    ],
  );
}

Widget _buildMarker({required BuildContext context}) {
  return Positioned.fill(
    child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).indicatorColor), //Change color
            width: 7.0,
            height: 7.0,
          ),
        )),
  );
}

CalendarBuilders<CalendarEvent> getBuilder(BuildContext context) {
  return CalendarBuilders(
    todayBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(context: context, day: day);
    },
    outsideBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          textColor: Theme.of(context).primaryColor);
    },
    defaultBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(context: context, day: day);
    },
    markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        return _buildMarker(context: context);
      }
    },
  );
}

CalendarBuilders<CalendarEvent> getPickerBuilder(BuildContext context) {
  return CalendarBuilders(
    rangeStartBuilder: (context, day, focusedDay) {
      return _buildRangeSelectDay(context: context, day: day);
    },
    rangeEndBuilder: (context, day, focusedDay) {
      return _buildRangeSelectDay(context: context, day: day);
    },
    withinRangeBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          textColor: Colors.white,
          backgroundColor: Theme.of(context).selectedRowColor);
    },
    // todayBuilder: (context, day, focusedDay) {
    //   return _buildCalendarDay(
    //       context: context,
    //       day: day,
    //       backgroundColor: Theme.of(context).primaryColorLight);
    // },
    outsideBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          textColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColorLight);
    },
    defaultBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          backgroundColor: Theme.of(context).primaryColorLight);
    },
    markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        return _buildMarker(context: context);
      }
    },
  );
}

import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_event.dart';

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
        shape: BoxShape.circle, color: Theme.of(context).colorScheme.blue),
    child: Center(
      child: Text(day.day.toString(),
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white)),
    ),
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
                color: Theme.of(context).colorScheme.green), //Change color
            width: 7.0,
            height: 7.0,
          ),
        )),
  );
}

CalendarBuilders<CalendarEvent> getBuilder(BuildContext context) {
  return CalendarBuilders(
    todayBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          backgroundColor: Theme.of(context).colorScheme.lightGrey1);
    },
    outsideBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          textColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).colorScheme.lightGrey1);
    },
    defaultBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          backgroundColor: Theme.of(context).colorScheme.lightGrey1);
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
          backgroundColor: Theme.of(context).colorScheme.lightGrey2);
    },
    outsideBuilder: (context, day, focusedDay) {
      return _buildCalendarDay(
          context: context,
          day: day,
          textColor: Theme.of(context).colorScheme.lightGrey1);
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

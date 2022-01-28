import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerActivator extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isDateSelected;
  final VoidCallback onPressed;
  final DateFormat format = DateFormat("yyyy년 MM월 dd일");

  DatePickerActivator(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.isDateSelected,
      required this.onPressed})
      : super(key: key);

  bool get _isDateRange => (isDateSelected && !isSameDay(startDate, endDate));

  String? get _selectedDates => isDateSelected
      ? isSameDay(startDate, endDate)
          ? format.format(startDate!)
          : "${format.format(startDate!)} ~ ${format.format(endDate!)}"
      : null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
              minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              )),
              backgroundColor: MaterialStateProperty.all(isDateSelected
                  ? Theme.of(context).colorScheme.blue
                  : Theme.of(context).colorScheme.lightGrey1),
              foregroundColor: MaterialStateProperty.all(_selectedDates == null
                  ? Theme.of(context).colorScheme.lightGrey2
                  : Colors.white),
              textStyle: MaterialStateProperty.all(_isDateRange
                  ? Theme.of(context).textTheme.headline3
                  : Theme.of(context).textTheme.headline2),
            ),
            child: Text(_selectedDates ?? "날짜를 선택해주세요")),
      ),
    );
  }
}

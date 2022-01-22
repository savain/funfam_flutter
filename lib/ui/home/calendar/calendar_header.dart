import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = '${focusedDay.year}년 ${focusedDay.month}월';

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 18,
              ),
              onPressed: onLeftArrowTap,
            ),
            Expanded(
                child: Center(
                    child: Text(
              headerText,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black),
            ))),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                size: 18,
              ),
              onPressed: onRightArrowTap,
            ),
          ],
        ),
        Row(
          children: const [
            Expanded(
                child: Center(
              child: Text("sun"),
            )),
            Expanded(
                child: Center(
              child: Text("mon"),
            )),
            Expanded(
                child: Center(
              child: Text("tue"),
            )),
            Expanded(
                child: Center(
              child: Text("wed"),
            )),
            Expanded(
                child: Center(
              child: Text("thu"),
            )),
            Expanded(
                child: Center(
              child: Text("fri"),
            )),
            Expanded(
                child: Center(
              child: Text("sat"),
            )),
          ],
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }
}

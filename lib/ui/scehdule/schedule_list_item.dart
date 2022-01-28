import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:intl/intl.dart';

class ScheduleListItem extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleListItem({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("MM월 dd일");

    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.blue), //Change color
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              format.format(schedule.startDate.toDate()),
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.black),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                schedule.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(schedule.nickname,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).colorScheme.darkGrey)),
          ],
        ));
  }
}

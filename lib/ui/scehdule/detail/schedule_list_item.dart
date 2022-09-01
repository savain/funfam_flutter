import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/component/user_avartar.dart';
import 'package:fun_fam/model/ScheduleModel.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:intl/intl.dart';

class ScheduleListItem extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback onDeleted;

  const ScheduleListItem(
      {Key? key, required this.schedule, required this.onDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("MM월 dd일");

    return Container(
        color: Theme.of(context).colorScheme.lightGrey1,
        margin: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserAvatar(uid: schedule.uid, size: 70),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.nickname,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.blue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  (schedule.startDate == schedule.endDate)
                                      ? format
                                          .format(schedule.startDate.toDate())
                                      : "${format.format(schedule.startDate.toDate())} ~ ${format.format(schedule.endDate.toDate())}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    schedule.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    schedule.schedule,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
            // if (schedule.uid == FirebaseAuth.instance.currentUser?.uid)
            Positioned(
                top: 25,
                right: 25,
                child: IconButton(
                  iconSize: 25,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    onDeleted();
                  },
                ))
          ],
        ));
  }
}

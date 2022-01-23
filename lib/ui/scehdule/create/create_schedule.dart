import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fun_fam/component/loading_overlay.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'date_picker.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({Key? key}) : super(key: key);

  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/ic_back.svg"),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [Image.asset("assets/ic_noti.png")],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: IntrinsicWidth(
              child: TextButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
                      expand: false,
                      isDismissible: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ScheduleDatePicker(),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20)),
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.lightGrey1),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.lightGrey2),
                    textStyle: MaterialStateProperty.all(
                        Theme.of(context).textTheme.headline2),
                  ),
                  child: const Text("날짜를 선택해주세요")),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      )),
    );
  }
}

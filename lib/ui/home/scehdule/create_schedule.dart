import 'package:flutter/material.dart';
import 'package:fun_fam/component/loading_overlay.dart';
import 'package:go_router/go_router.dart';

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
          icon: Image.asset("assets/ic_back.png"),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [Image.asset("assets/ic_noti.png")],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}

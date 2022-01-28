import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';

class ScheduleContentInput extends StatelessWidget {
  final bool isShow;
  final FocusNode focus;
  final Function(String title) onChanged;

  const ScheduleContentInput(
      {Key? key,
      required this.isShow,
      required this.focus,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 450),
      child: AnimatedOpacity(
        opacity: isShow ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          height: isShow ? 200 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
                focusNode: focus,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).colorScheme.black),
                onChanged: onChanged,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.lightGrey2,
                      width: 1.0,
                    ),
                  ),
                  hintText: "스케줄을 작성해주세요",
                  labelText: "스케줄",
                  labelStyle: Theme.of(context).textTheme.headline2!.copyWith(
                      height: 0.5,
                      color: Theme.of(context).colorScheme.lightGrey2),
                  floatingLabelStyle: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(
                          height: 0.5,
                          color: Theme.of(context).colorScheme.blue),
                  hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Theme.of(context).colorScheme.lightGrey2),
                )),
          ),
        ),
      ),
    );
  }
}

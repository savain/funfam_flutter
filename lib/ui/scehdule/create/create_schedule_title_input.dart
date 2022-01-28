import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_fam/theme/FunFamColorScheme.dart';

class ScheduleTitleInput extends StatelessWidget {
  final bool isShow;
  final FocusNode focus;
  final Function(String title) onChanged;
  final Function() onEditingComplete;

  const ScheduleTitleInput(
      {Key? key,
      required this.isShow,
      required this.focus,
      required this.onChanged,
      required this.onEditingComplete})
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
          height: isShow ? 80 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
                focusNode: focus,
                keyboardType: TextInputType.text,
                maxLines: 1,
                onEditingComplete: onEditingComplete,
                onChanged: onChanged,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Theme.of(context).colorScheme.black),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.blue),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.lightGrey2),
                  ),
                  hintText: "제목을 작성해주세요",
                  labelText: "제목",
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

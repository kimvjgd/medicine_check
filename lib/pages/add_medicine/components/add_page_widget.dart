import 'package:flutter/material.dart';
import 'package:medicine_check/components/dory_constants.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: pagePadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children),),);
  }
}

class BottomSubmitButton extends StatelessWidget {
  BottomSubmitButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1),
              onPressed: onPressed,
              child: Text(text),
            ),
          ),
        ));
  }
}

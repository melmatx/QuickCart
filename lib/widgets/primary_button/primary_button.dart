import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const PrimaryButton({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}

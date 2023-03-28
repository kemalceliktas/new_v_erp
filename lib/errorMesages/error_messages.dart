import 'package:flutter/material.dart';

class Messages {
  SnackBar error(
      {required Duration duration,
      required String message,
      required BuildContext context}) {
    return SnackBar(
      backgroundColor: Colors.red,
      content: Center(
          child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium,
      )),
      duration: duration,
    );
  }
}

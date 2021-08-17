import 'package:flutter/material.dart';

import '../theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key, this.onPressed})
      : super(key: key);
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onPressed!();
      },
      child: Icon(
        Icons.add,
        color: AppTheme.strongOne,
        size: h! * 5,
      ),
      backgroundColor: AppTheme.lightOne,
    );
  }
}

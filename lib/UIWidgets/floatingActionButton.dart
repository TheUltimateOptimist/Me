import 'package:flutter/material.dart';

import '../theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(
        Icons.add,
        color: AppTheme.strongOne,
        size: h! * 5,
      ),
      backgroundColor: AppTheme.lightOne,
    );
  }
}

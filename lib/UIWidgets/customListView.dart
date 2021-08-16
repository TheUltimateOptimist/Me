import 'package:flutter/material.dart';

import '../theme.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    Key? key,
    required this.onPressed,
    required this.titles,
    required this.addGarbageCan,
    this.subtitles,
    this.trailing,
    this.leading,
  }) : super(key: key);
  final Function onPressed;
  final List<String> titles;
  final List<Text>? subtitles;
  final bool addGarbageCan;
  final Widget? leading;
  final List<Widget>? trailing;

  dynamic actualSubTitle(int index) {
    if (subtitles == null) {
      return null;
    } else
      return subtitles![index];
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> trailingChildren;
    if (addGarbageCan) {
      trailingChildren = [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.delete,
            size: h! * 3,
            color: AppTheme.lightOne,
          ),
        ),
      ];
      if (trailing != null) {
        for (var element in trailing!) {
          trailingChildren.add(element);
        }
        trailingChildren = trailingChildren.reversed.toList();
      }
    }
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: leading,
            onTap: onPressed(),
            subtitle: actualSubTitle(index),
            title: Text(
              titles[index],
              style: TextStyle(
                color: AppTheme.lightOne,
                fontSize: h! * 3,
              ),
            ),
            tileColor: AppTheme.strongTwo,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingChildren,
            ),
          );
        });
  }
}

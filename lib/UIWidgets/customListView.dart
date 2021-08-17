import 'package:flutter/material.dart';

import '../theme.dart';

class CustomListView extends StatelessWidget {
  const CustomListView(
      {Key? key,
      required this.onPressed,
      required this.titles,
      required this.addGarbageCan,
      this.subtitles,
      this.trailing,
      this.leading,
      this.showCompletionStatus = false,
      this.completionStatuses,
      this.indexToInsertCompletionStatus = 0})
      : super(key: key);
  final Function onPressed;
  final List<String> titles;
  final List<Text>? subtitles;
  final bool addGarbageCan;
  final Widget? leading;
  final List<Widget>? trailing;
  final bool showCompletionStatus;
  final List<int>? completionStatuses;
  final int indexToInsertCompletionStatus;

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
      if (showCompletionStatus) {
        trailingChildren.insert(indexToInsertCompletionStatus, Container());
      }
    }
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          if (showCompletionStatus && completionStatuses![index] == 1) {
            trailingChildren[indexToInsertCompletionStatus] = Icon(
              Icons.check,
              color: Colors.green,
              size: h! * 3,
            );
          } else if (showCompletionStatus && completionStatuses![index] == 0) {
            trailingChildren[indexToInsertCompletionStatus] = Icon(
              Icons.cancel,
              color: AppTheme.strongOne,
              size: h! * 3,
            );
          }
          return ListTile(
            leading: leading,
            onTap: onPressed(),
            subtitle: actualSubTitle(index),
            title: Text(
              titles[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

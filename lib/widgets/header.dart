import 'package:flutter/material.dart';

header({
  BuildContext context,
  String title,
  bool isAppTitle = false,
  removeBackButton = false,
}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Flutter Connect' : title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 50.0 : 20.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}

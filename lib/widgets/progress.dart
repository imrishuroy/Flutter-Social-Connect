import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    // width is new added data
    width: 100,
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.purple,
      ),
    ),
  );
}

// show liner progress indicator on the top
Widget linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.purple,
      ),
    ),
  );
}

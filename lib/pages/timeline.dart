import 'package:flutter/material.dart';
import 'package:social_connect/widgets/header.dart';
import 'package:social_connect/widgets/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context: context, title: 'TimeLine'),
        body: circularProgress());
  }
}

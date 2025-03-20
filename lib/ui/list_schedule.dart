import 'package:flutter/material.dart';

class ListSchedule extends StatefulWidget {
  const ListSchedule({super.key});

  @override
  State<ListSchedule> createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Schedule"),
      ),
      body: Center(
        child: Text("Nothing Schedule To Show"),
      ),
    );
  }
}

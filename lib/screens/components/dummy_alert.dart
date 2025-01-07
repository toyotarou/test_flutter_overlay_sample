import 'package:flutter/material.dart';

class DummyAlert extends StatefulWidget {
  const DummyAlert({super.key});

  @override
  State<DummyAlert> createState() => _DummyAlertState();
}

class _DummyAlertState extends State<DummyAlert> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: List.generate(10, (index) => Text(index.toString())),
            ),
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_general_dialog_sample/extensions/extensions.dart';
import 'package:test_general_dialog_sample/screens/components/dummy_alert.dart';

import 'package:test_general_dialog_sample/screens/parts/overlay_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<OverlayEntry> _overlayEntries = [];

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddOverlay Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                addOverlay(
                  context: context,
                  entries: _overlayEntries,
                  setStateCallback: setState,
                  width: 300,
                  height: 300,
                  color: Colors.indigo,
                  initialPosition: Offset((context.screenSize.width - 300), 100),
                  widget: const DummyAlert(),
                );
              },
              child: const Text('Add Big Overlay'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addOverlay(
                  context: context,
                  entries: _overlayEntries,
                  setStateCallback: setState,
                  width: 200,
                  height: 200,
                  color: Colors.green,
                  initialPosition: Offset(200, (context.screenSize.height - 200)),
                  widget: const DummyAlert(),
                );
              },
              child: const Text('Add Small Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}

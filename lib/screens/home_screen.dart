import 'package:flutter/material.dart';
import 'package:test_general_dialog_sample/screens/components/dummy_alert.dart';
import 'package:test_general_dialog_sample/screens/parts/overlay_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<OverlayEntry> _bigEntries = [];

  final List<OverlayEntry> _smallEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Separate Overlays Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                addBigOverlay(
                  context: context,
                  bigEntries: _bigEntries,
                  setStateCallback: setState,
                  width: 300,
                  height: 200,
                  color: Colors.blueGrey,
                  initialPosition: const Offset(80, 150),
                  widget: const DummyAlert(),
                );
              },
              child: const Text('Show Big Overlay'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addSmallOverlay(
                  context: context,
                  smallEntries: _smallEntries,
                  setStateCallback: setState,
                  width: 180,
                  height: 120,
                  color: Colors.deepOrange,
                  initialPosition: const Offset(200, 80),
                  widget: const DummyAlert(),
                );
              },
              child: const Text('Show Small Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:test_general_dialog_sample/overlay_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AddOverlay Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

//=======================================================//

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  height: 150,
                  color: Colors.indigo,
                  initialPosition: const Offset(50, 80),
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
                  height: 100,
                  color: Colors.green,
                  initialPosition: const Offset(100, 120),
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

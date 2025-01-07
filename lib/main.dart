import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  OverlayEntry? _overlayEntry;

  ///
  void _showOverlay(BuildContext context) {
    // 既に表示中なら何もしない
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);

    // オーバーレイで表示するウィジェット
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          // 表示位置を自由に指定できる
          top: 100,
          right: 10,
          child: Material(
            elevation: 8,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 200,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Overlay Popup'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // ボタンを押すとOverlayを消去
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // 実際に追加
    overlayState.insert(_overlayEntry!);
  }

  ///
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Counter: $_counter'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _showOverlay(context), child: const Text('Overlayを表示')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _removeOverlay, child: const Text('Overlayを消す')),
            const SizedBox(height: 40),
            const Text('↓ Overlay表示中でも押せるボタン ↓'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('カウンターを増やす'),
            ),
          ],
        ),
      ),
    );
  }
}

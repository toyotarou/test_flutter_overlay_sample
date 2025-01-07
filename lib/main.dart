import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// メインアプリ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple Draggable Overlays (Safe Implementation)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

/// ホーム画面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// OverlayEntry と 座標を1つにしたクラス
class DraggableOverlayItem {
  /// OverlayEntry（表示するウィジェットそのもの）
  OverlayEntry entry;

  /// 現在の表示位置（左上座標）
  Offset position;

  DraggableOverlayItem({
    required this.entry,
    required this.position,
  });
}

/// ホーム画面のState
class _HomePageState extends State<HomePage> {
  /// 複数のオーバーレイをリストで管理
  final List<DraggableOverlayItem> _items = [];

  // オーバーレイの幅・高さ
  static const double _overlayWidth = 200;
  static const double _overlayHeight = 120;

  /// OverlayEntryを作る際の共通ロジック
  /// indexやリストを直接参照しないで済むように、各Itemが自分のEntryと座標を内包
  OverlayEntry _createOverlayEntry(BuildContext context, DraggableOverlayItem item) {
    return OverlayEntry(
      builder: (context) {
        // 画面サイズを取得して、クランプ処理に使用
        final screenSize = MediaQuery.of(context).size;

        // 現在の座標
        final position = item.position;

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: _DraggableOverlay(
            width: _overlayWidth,
            height: _overlayHeight,
            color: Colors.primaries[_items.indexOf(item) % Colors.primaries.length],
            onDragUpdate: (delta) {
              // ドラッグ移動量を加算
              item.position += delta;

              // 画面端にはみ出さないようにクランプ
              final double maxX = screenSize.width - _overlayWidth;
              final double maxY = screenSize.height - _overlayHeight;
              final clampedX = item.position.dx.clamp(0, maxX);
              final clampedY = item.position.dy.clamp(0, maxY);
              item.position = Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

              // 再描画
              item.entry.markNeedsBuild();
            },
            onClose: () {
              // 1) まず OverlayEntry.remove() で消す
              item.entry.remove();

              // 2) 次のフレームでリストから削除（RangeError回避対策）
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _items.remove(item);
                  });
                }
              });
            },
          ),
        );
      },
    );
  }

  /// 新しいオーバーレイを追加表示
  void _addNewOverlay(BuildContext context) {
    final overlayState = Overlay.of(context);

    // 初期位置 (重ならないよう少しずらしてもOK)
    final initialOffset = Offset(
      50 + 30.0 * _items.length,
      100 + 30.0 * _items.length,
    );

    // Item作成（entryはまだ作っていない）
    late DraggableOverlayItem item;
    item = DraggableOverlayItem(
      position: initialOffset,
      entry: OverlayEntry(builder: (_) => const SizedBox()), // 仮のentry
    );

    // entry を本作成してItemに差し替え
    final newEntry = _createOverlayEntry(context, item);
    item.entry = newEntry;

    // リストに登録
    setState(() {
      _items.add(item);
    });

    // Overlayに挿入
    overlayState.insert(newEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Draggable Overlays (Safe)'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _addNewOverlay(context),
          child: const Text('Add New Draggable Overlay'),
        ),
      ),
    );
  }
}

/// 実際の「ドラッグで移動可能 + 閉じるボタン」のウィジェット
class _DraggableOverlay extends StatelessWidget {
  final double width;
  final double height;
  final MaterialColor color;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onClose;

  const _DraggableOverlay({
    required this.width,
    required this.height,
    required this.color,
    required this.onDragUpdate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onDragUpdate(details.delta),
      child: Material(
        elevation: 8,
        color: color.shade200,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Draggable Overlay',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onClose,
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

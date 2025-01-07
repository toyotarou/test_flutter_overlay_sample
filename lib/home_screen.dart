import 'package:flutter/material.dart';

import 'draggable_overlay_item.dart';
import 'my_draggable_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<DraggableOverlayItem> _items = [];

  static const double _overlayWidth = 200;
  static const double _overlayHeight = 120;

  ///
  OverlayEntry _createOverlayEntry(BuildContext context, DraggableOverlayItem item) {
    return OverlayEntry(
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;

        final position = item.position;

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: MyDraggableOverlay(
            width: _overlayWidth,
            height: _overlayHeight,
            color: Colors.primaries[_items.indexOf(item) % Colors.primaries.length],
            onDragUpdate: (delta) {
              item.position += delta;

              final double maxX = screenSize.width - _overlayWidth;

              final double maxY = screenSize.height - _overlayHeight;

              final clampedX = item.position.dx.clamp(0, maxX);

              final clampedY = item.position.dy.clamp(0, maxY);

              item.position = Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

              item.entry.markNeedsBuild();
            },
            onClose: () {
              item.entry.remove();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _items.remove(item));
                }
              });
            },
          ),
        );
      },
    );
  }

  ///
  void _addNewOverlay(BuildContext context) {
    final overlayState = Overlay.of(context);

    final initialOffset = Offset(50 + 30.0 * _items.length, 100 + 30.0 * _items.length);

    late DraggableOverlayItem item;

    item = DraggableOverlayItem(position: initialOffset, entry: OverlayEntry(builder: (_) => const SizedBox()));

    final newEntry = _createOverlayEntry(context, item);

    item.entry = newEntry;

    setState(() => _items.add(item));

    overlayState.insert(newEntry);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Draggable Overlays (Safe)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _addNewOverlay(context),
          child: const Text('Add New Draggable Overlay'),
        ),
      ),
    );
  }
}

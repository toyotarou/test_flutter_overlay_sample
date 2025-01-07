import 'package:flutter/material.dart';

class MyDraggableOverlay extends StatefulWidget {
  final double width;
  final double height;
  final MaterialColor color;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onClose;

  const MyDraggableOverlay({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.onDragUpdate,
    required this.onClose,
  });

  @override
  State<MyDraggableOverlay> createState() => _MyDraggableOverlayState();
}

class _MyDraggableOverlayState extends State<MyDraggableOverlay> {
  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => widget.onDragUpdate(details.delta),
      child: Material(
        elevation: 8,
        color: widget.color.shade200,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Draggable Overlay'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: widget.onClose,
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

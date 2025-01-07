import 'package:flutter/material.dart';

//=======================================================//

class DraggableOverlayItem {
  late OverlayEntry entry;

  Offset position;

  final double width;
  final double height;

  final Color color;

  DraggableOverlayItem({required this.position, required this.width, required this.height, required this.color});
}

//=======================================================//

///
OverlayEntry createDraggableOverlayEntry({
  required BuildContext context,
  required Offset initialOffset,
  required double width,
  required double height,
  required Color color,
  required VoidCallback onRemove,
  required Widget widget,
}) {
  final screenSize = MediaQuery.of(context).size;

  final item = DraggableOverlayItem(position: initialOffset, width: width, height: height, color: color);

  final entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        left: item.position.dx,
        top: item.position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            item.position += details.delta;

            final maxX = screenSize.width - item.width;
            final maxY = screenSize.height - item.height;
            final clampedX = item.position.dx.clamp(0, maxX);
            final clampedY = item.position.dy.clamp(0, maxY);
            item.position = Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

            item.entry.markNeedsBuild();
          },
          child: Material(
            elevation: 8,
            color: item.color,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: item.width,
              height: item.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Width: ${item.width}, Height: ${item.height}', style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  widget,
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => onRemove(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  item.entry = entry;
  return entry;
}

//=======================================================//

void addOverlay({
  required BuildContext context,
  required List<OverlayEntry> entries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
}) {
  late OverlayEntry entry;

  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      entry.remove();

      setStateCallback(() => entries.remove(entry));
    },
    widget: widget,
  );

  setStateCallback(() => entries.add(entry));

  Overlay.of(context).insert(entry);
}

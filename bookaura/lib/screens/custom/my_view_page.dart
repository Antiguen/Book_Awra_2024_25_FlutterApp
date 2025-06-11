import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod providers for the view's state
final exampleStringProvider = StateProvider<String>((ref) => "Hello, BookAura!");
final exampleColorProvider = StateProvider<Color>((ref) => Colors.red);
final exampleDimensionProvider = StateProvider<double>((ref) => 32.0);
final exampleDrawableProvider = StateProvider<ImageProvider?>((ref) => null);

class MyViewPage extends ConsumerWidget {
  const MyViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exampleString = ref.watch(exampleStringProvider);
    final exampleColor = ref.watch(exampleColorProvider);
    final exampleDimension = ref.watch(exampleDimensionProvider);
    final exampleDrawable = ref.watch(exampleDrawableProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("MyView Example", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(300, 200),
          painter: _MyViewPainter(
            text: exampleString,
            color: exampleColor,
            fontSize: exampleDimension,
            drawable: exampleDrawable,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB17979),
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          // Example: Change state using Riverpod
          ref.read(exampleStringProvider.notifier).state = "Riverpod Rocks!";
          ref.read(exampleColorProvider.notifier).state = Colors.green;
          ref.read(exampleDimensionProvider.notifier).state = 40.0;
        },
      ),
    );
  }
}

class _MyViewPainter extends CustomPainter {
  final String text;
  final Color color;
  final double fontSize;
  final ImageProvider? drawable;

  _MyViewPainter({
    required this.text,
    required this.color,
    required this.fontSize,
    this.drawable,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Draw the text
    textPainter.paint(canvas, textOffset);

    // Draw the drawable above the text if provided
    if (drawable != null) {
      final paint = Paint();
      final imageRect = Rect.fromLTWH(
        (size.width - 64) / 2,
        16,
        64,
        64,
      );
      paint.color = Colors.white24;
      canvas.drawRect(imageRect, paint);
      // For real images, use a widget tree, not CustomPainter
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
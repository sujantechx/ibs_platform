import 'package:flutter/material.dart';

class TextViewerScreen extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double lineHeight;
  final double paragraphSpacing;

  const TextViewerScreen({
    Key? key,
    required this.text,
    this.align = TextAlign.left,
    this.lineHeight = 1.5,
    this.paragraphSpacing = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.split(RegExp(r'\n\s*\n')).map((p) => p.trim()).where((p) => p.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Text Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: align == TextAlign.left
              ? CrossAxisAlignment.start
              : align == TextAlign.right
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          children: paragraphs
              .map(
                (p) => Padding(
              padding: EdgeInsets.only(bottom: paragraphSpacing),
              child: SelectableText(
                p,
                textAlign: align,
                style: TextStyle(height: lineHeight, fontSize: 16),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

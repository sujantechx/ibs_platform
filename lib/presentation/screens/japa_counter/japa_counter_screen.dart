// lib/presentation/screens/japa_counter/japa_counter_screen.dart

import 'package:flutter/material.dart';

class JapaCounterScreen extends StatefulWidget {
  const JapaCounterScreen({super.key});

  @override
  _JapaCounterScreenState createState() => _JapaCounterScreenState();
}

class _JapaCounterScreenState extends State<JapaCounterScreen> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  void _resetCounter() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Japa Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}

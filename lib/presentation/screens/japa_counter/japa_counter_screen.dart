// lib/presentation/screens/japa_counter/japa_counter_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class JapaCounterScreen extends StatefulWidget {
  const JapaCounterScreen({super.key});

  @override
  _JapaCounterScreenState createState() => _JapaCounterScreenState();
}

class _JapaCounterScreenState extends State<JapaCounterScreen> {
  static const _kCountKey = 'japa_count';
  static const _kLastResetKey = 'japa_last_reset_ms';
  static const _kRoundsKey = 'japa_rounds';
  static const _kResetDuration = Duration(hours: 24);

  int _count = 0;
  int _rounds = 0;
  DateTime? _lastReset;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCount = prefs.getInt(_kCountKey) ?? 0;
    final savedRounds = prefs.getInt(_kRoundsKey) ?? 0;
    final lastResetMs = prefs.getInt(_kLastResetKey);
    final lastReset = lastResetMs != null ? DateTime.fromMillisecondsSinceEpoch(lastResetMs) : null;

    // If the saved timestamp is older than 24 hours, reset.
    final now = DateTime.now();
    final needsReset = lastReset == null || now.difference(lastReset) >= _kResetDuration;

    if (needsReset) {
      // start fresh and set lastReset to now
      setState(() {
        _count = 0;
        _lastReset = now;
        _rounds = 0;
      });
      await _saveState();
    } else {
      setState(() {
        _count = savedCount;
        _lastReset = lastReset;
        _rounds = savedRounds;
      });
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCountKey, _count);
    await prefs.setInt(_kRoundsKey, _rounds);
    if (_lastReset != null) {
      await prefs.setInt(_kLastResetKey, _lastReset!.millisecondsSinceEpoch);
    }
  }

  Future<void> _addCounts(int add) async {
    if (add <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastResetMs = prefs.getInt(_kLastResetKey);
    final lastReset = lastResetMs != null ? DateTime.fromMillisecondsSinceEpoch(lastResetMs) : null;

    // If more than 24h passed since last reset, reset first
    if (lastReset == null || now.difference(lastReset) >= _kResetDuration) {
      setState(() {
        _count = 0;
        _rounds = 0;
        _lastReset = now;
      });
      await _saveState();
    }

    final total = _count + add;
    final completedRounds = total ~/ 108;
    final remainder = total % 108;

    setState(() {
      _rounds += completedRounds;
      _count = remainder;
    });

    // persist
    await _saveState();

    if (completedRounds > 0) {
      // show dialog and offer SMS
      if (mounted) _showRoundCompleteDialog(context, completedRounds, _rounds);
    }
  }

  Future<void> _incrementCounter() async {
    await _addCounts(1);
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController(text: '108');
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Number counts'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            // decoration: const InputDecoration(labelText: 'Number '),
          ),
          // actions: [
          //   TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          //   TextButton(
          //     onPressed: () {
          //       final value = int.tryParse(controller.text.trim()) ?? 0;
          //       Navigator.of(ctx).pop();
          //       if (value > 0) _addCounts(value);
          //     },
          //     child: const Text('Add'),
          //   ),
          // ],
        );
      },
    );
  }

  Future<void> _showRoundCompleteDialog(BuildContext context, int roundsCompletedThisAction, int totalRounds) async {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Round complete!')));

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Round(s) complete'),
          content: Text('You completed $roundsCompletedThisAction round(s) in this action. Total rounds: $totalRounds.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _sendSms(totalRounds);
              },
              child: const Text('Send SMS'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendSms(int totalRounds) async {
    final message = 'I completed $totalRounds round(s) of Japa.';
    final uri = Uri.parse('sms:?body=${Uri.encodeComponent(message)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open SMS app on this device.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open SMS: $e')));
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _incrementCounter, child: const Text('Increment')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _showAddDialog, child: const Text('Total')),
              ],
            ),
            const SizedBox(height: 10),
            Text('Rounds: $_rounds'),
            const SizedBox(height: 6),
            if (_lastReset != null) Text('Reset at: ${_lastReset!.toLocal()}'),
          ],
        ),
      ),
    );
  }
}

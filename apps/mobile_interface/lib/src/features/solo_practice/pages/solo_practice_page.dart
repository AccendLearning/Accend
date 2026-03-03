import 'package:flutter/material.dart';

class SoloPracticePage extends StatefulWidget {
  const SoloPracticePage({super.key});

  @override
  State<SoloPracticePage> createState() => _SoloPracticePageState();
}

class _SoloPracticePageState extends State<SoloPracticePage> {
  int _micStateIndex = 0; // 0 = mic, 1 = recording, 2 = play

  void _onMicPressed() {
    setState(() {
      _micStateIndex = (_micStateIndex + 1) % 3;
    });
  }

  IconData _currentMicIcon() {
    switch (_micStateIndex) {
      case 1:
        return Icons.fiber_manual_record; // circle for recording
      case 2:
        return Icons.play_arrow; // play icon
      case 0:
      default:
        return Icons.mic; // default mic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top section: back button above centered progress/info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            Text('1/20'),
                            Spacer(),
                            Text('Lesson Title'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const LinearProgressIndicator(
                          value: 0.2, // placeholder for now
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Middle section: prompt box and text to repeat
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // Placeholder for prompt box
                    SizedBox(
                      height: 120,
                      width: 280,
                      child: Card(
                        child: Center(
                          child: Text('Folks, this is fantastic!'),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Record yourself using the microphone button below!'),
                  ],
                ),
              ),
            ),
            // Bottom section: controls (microphone button for now)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2, // thicker outline
                      ),
                    ),
                    child: IconButton(
                      onPressed: _onMicPressed,
                      icon: Icon(_currentMicIcon()),
                      iconSize: 56,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

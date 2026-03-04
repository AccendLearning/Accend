import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

const List<String> _mockCards = [
  'The quick brown fox jumped over the lazy dog.',
  'She sells seashells by the seashore.',
  'How much wood would a woodchuck chuck?',
  'Peter Piper picked a peck of pickled peppers.',
  'I scream, you scream, we all scream for ice cream.',
  'Red lorry, yellow lorry.',
  'Unique New York, unique New York.',
  'Buffalo buffalo Buffalo buffalo buffalo buffalo Buffalo buffalo.',
  'The sixth sick sheikh\'s sixth sheep\'s sick.',
  'Fresh French fried fish fingers.',
  'I saw Susie sitting in a shoeshine shop.',
  'Lesser leather never weathered wetter weather better.',
  'Can you can a can as a canner can can a can?',
  'Willy\'s real rear wheel.',
  'The thirty-three thieves thought that they thrilled the throne.',
  'Six sleek swans swam swiftly southwards.',
  'How can a clam cram in a clean cream can?',
  'Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair.',
  'Near an ear, a nearer ear, a nearly eerie ear.',
  'You\'ve done it! Great work completing the lesson.',
];

class SoloPracticePage extends StatefulWidget {
  const SoloPracticePage({super.key});

  @override
  State<SoloPracticePage> createState() => _SoloPracticePageState();
}

class _SoloPracticePageState extends State<SoloPracticePage> {
  int _currentCardIndex = 0;
  int _micStateIndex = 0; // 0 = mic, 1 = recording, 2 = play
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const String _sampleAudioAsset = 'audio/testaudio.wav';

  int get _totalCards => _mockCards.length;
  String get _currentCard => _mockCards[_currentCardIndex];
  double get _progress => (_currentCardIndex + 1) / _totalCards;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _onMicPressed() async {
    if (_micStateIndex < 2) {
      setState(() {
        _micStateIndex += 1;
      });
    } else {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(_sampleAudioAsset));
      } catch (_) {}
    }
  }

  void _onRetryPressed() {
    setState(() {
      _micStateIndex = 0;
    });
  }

  void _onSubmitPressed() {
    if (_currentCardIndex < _totalCards - 1) {
      setState(() {
        _currentCardIndex += 1;
        _micStateIndex = 0;
      });
    } else {
      // Completed all cards
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lesson Complete! 🎉'),
          content: const Text('You\'ve completed all 20 exercises. Great work!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      );
    }
  }

  IconData _currentMicIcon() {
    switch (_micStateIndex) {
      case 1:
        return Icons.fiber_manual_record;
      case 2:
        return Icons.play_arrow;
      case 0:
      default:
        return Icons.mic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showRetrySubmit = _micStateIndex == 2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
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
                          children: [
                            Text('${_currentCardIndex + 1}/$_totalCards'),
                            const Spacer(),
                            const Text('Lesson Title'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _progress,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Middle section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 280,
                      child: Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              _currentCard,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Record yourself using the microphone button below!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showRetrySubmit) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onRetryPressed,
                        child: const Text('Retry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      onPressed: _onMicPressed,
                      child: Icon(
                        _currentMicIcon(),
                        size: 56,
                      ),
                    ),
                  ),
                  if (showRetrySubmit) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSubmitPressed,
                        child: Text(
                          _currentCardIndex == _totalCards - 1
                              ? 'Finish'
                              : 'Submit',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
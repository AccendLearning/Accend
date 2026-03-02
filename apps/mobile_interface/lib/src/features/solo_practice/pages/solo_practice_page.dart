import 'package:flutter/material.dart';

class SoloPracticePage extends StatelessWidget {
  const SoloPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solo Practice'),
      ),
      body: const Center(
        child: Text('Solo Practice Page'),
      ),
    );
  }
}


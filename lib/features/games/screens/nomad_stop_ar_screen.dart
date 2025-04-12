// lib/features/games/screens/nomad_stop_ar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:kodonomad/features/games/providers/nomad_quest_provider.dart';

class NomadStopARScreen extends ConsumerStatefulWidget {
  final NomadStop stop;

  const NomadStopARScreen({required this.stop});

  @override
  _NomadStopARScreenState createState() => _NomadStopARScreenState();
}

class _NomadStopARScreenState extends ConsumerState<NomadStopARScreen> {
  ArCoreController? arCoreController;
  final _answerController = TextEditingController();
  bool _showTrivia = false;
  bool _artifactCollected = false;

  @override
  void dispose() {
    arCoreController?.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // Add a 3D artifact model (simplified as a sphere for now)
    final material = ArCoreMaterial(
      color: Colors.blue,
      reflectance: 1.0,
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.2,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: ArCoreVector3(0, 0, -1.0), // 1 meter in front of the camera
    );
    arCoreController!.addArCoreNode(node);

    // Show Nimbus.ai agent (simulated as a text overlay for now)
    setState(() {
      _showTrivia = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          if (_showTrivia && !_artifactCollected) ...[
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Nimbus.ai: Let’s test your knowledge!'),
                      const SizedBox(height: 8),
                      Text(widget.stop.triviaQuestion),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(labelText: 'Answer'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_answerController.text.toLowerCase() == widget.stop.triviaAnswer.toLowerCase()) {
                            ref.read(nomadQuestProvider.notifier).collectArtifact(widget.stop.id, widget.stop.artifactId);
                            setState(() {
                              _artifactCollected = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Correct! Artifact collected!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Incorrect answer. Try again!')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (_artifactCollected) ...[
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Nimbus.ai: Great job! You’ve collected the artifact from ${widget.stop.name}.'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

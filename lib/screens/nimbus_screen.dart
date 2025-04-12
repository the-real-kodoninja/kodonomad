import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/nimbus_service.dart';

class NimbusScreen extends ConsumerStatefulWidget {
  const NimbusScreen();
  @override
  _NimbusScreenState createState() => _NimbusScreenState();
}

class _NimbusScreenState extends ConsumerState<NimbusScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  Widget build(BuildContext context) {
    final nimbus = ref.watch(nimbusServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Nimbus')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]['role']!),
                subtitle: Text(_messages[index]['content']!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Ask Nimbus...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final message = _controller.text;
                    if (message.isEmpty) return;
                    setState(() {
                      _messages.add({'role': 'User', 'content': message});
                    });
                    _controller.clear();
                    final reply = await nimbus.chat(message);
                    setState(() {
                      _messages.add({'role': 'Nimbus', 'content': reply});
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

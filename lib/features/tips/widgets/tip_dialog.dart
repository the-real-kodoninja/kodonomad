import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tip_provider.dart';

class TipDialog extends ConsumerStatefulWidget {
  final int receiverId;

  const TipDialog({required this.receiverId});

  @override
  _TipDialogState createState() => _TipDialogState();
}

class _TipDialogState extends ConsumerState<TipDialog> {
  final _amountController = TextEditingController();
  String _currency = 'USD';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send a Tip'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: _currency,
            items: ['USD', 'ETH', 'BTC'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (value) => setState(() => _currency = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.parse(_amountController.text);
            ref.read(tipProvider.notifier).sendTip(1, widget.receiverId, amount, _currency);
            Navigator.pop(context);
          },
          child: const Text('Send Tip'),
        ),
      ],
    );
  }
}

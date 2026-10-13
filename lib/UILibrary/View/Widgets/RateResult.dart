import 'package:flutter/material.dart';

class RateResult {
  const RateResult({required this.rating, required this.comment});

  final double rating;
  final String comment;
}

Future<RateResult?> showRateDialog(
    BuildContext context, {
      required String providerName,
    }) {
  return showDialog<RateResult>(
    context: context,
    builder: (context) => _RateDialog(providerName: providerName),
  );
}

class _RateDialog extends StatefulWidget {
  const _RateDialog({required this.providerName});

  final String providerName;

  @override
  State<_RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<_RateDialog> {
  final TextEditingController _comment = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate ${widget.providerName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(5, (index) {
              final int star = index + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = star.toDouble()),
                icon: Icon(
                  star <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: const Color(0xFFF5A524),
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'Add a comment (optional)',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            RateResult(rating: _rating, comment: _comment.text.trim()),
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

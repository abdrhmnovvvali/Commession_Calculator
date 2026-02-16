import 'package:flutter/material.dart';

import '../../../../core/models/commission_result.dart';

class CommissionResultCard extends StatelessWidget {
  const CommissionResultCard({super.key, required this.result});

  final CommissionResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '${result.transactionIndex}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                result.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '${_formatCommission(result.commission)} ${result.currency}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCommission(double commission) {
    if (commission == commission.truncateToDouble()) {
      return commission.toInt().toString();
    }
    return commission.toStringAsFixed(2);
  }
}

import 'package:equatable/equatable.dart';

import '../../core/models/commission_result.dart';
import '../../core/models/transaction.dart';

class CommissionCalculationResult extends Equatable {
  const CommissionCalculationResult({
    required this.transactions,
    required this.results,
  });

  final List<Transaction> transactions;
  final List<CommissionResult> results;

  @override
  List<Object?> get props => [transactions, results];
}

import 'package:equatable/equatable.dart';

class CommissionResult extends Equatable {
  const CommissionResult({
    required this.transactionIndex,
    required this.description,
    required this.commission,
    required this.currency,
    this.amountInEur,
    this.details,
  });

  final int transactionIndex;
  final String description;
  final double commission;
  final String currency;
  final double? amountInEur;
  final String? details;

  @override
  List<Object?> get props => [transactionIndex, description, commission, currency];
}

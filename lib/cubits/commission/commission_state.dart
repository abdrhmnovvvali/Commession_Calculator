part of 'commission_cubit.dart';

sealed class CommissionState extends Equatable {
  const CommissionState();

  @override
  List<Object?> get props => [];
}

final class CommissionInitial extends CommissionState {}

final class CommissionLoading extends CommissionState {}

final class CommissionSuccess extends CommissionState {
  const CommissionSuccess({
    required this.results,
    required this.transactions,
  });

  final List<CommissionResult> results;
  final List<Transaction> transactions;

  @override
  List<Object?> get props => [results, transactions];
}

final class CommissionFailure extends CommissionState {
  const CommissionFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

enum OperationType {
  deposit,
  withdraw,
}

enum UserType {
  private_,
  business,
}

class Transaction extends Equatable {
  const Transaction({
    required this.date,
    required this.userId,
    required this.userType,
    required this.operationType,
    required this.amount,
    required this.currency,
  });

  final String date;
  final int userId;
  final String userType;
  final String operationType;
  final double amount;
  final String currency;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'] as String,
      userId: (json['userId'] as num).toInt(),
      userType: json['userType'] as String,
      operationType: json['operationType'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  bool get isDeposit => operationType.toLowerCase() == 'deposit';
  bool get isWithdraw => operationType.toLowerCase() == 'withdraw';
  bool get isPrivateUser => userType.toLowerCase() == 'private';
  bool get isBusinessUser => userType.toLowerCase() == 'business';

  @override
  List<Object?> get props => [date, userId, userType, operationType, amount, currency];
}

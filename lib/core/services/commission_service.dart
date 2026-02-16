import '../models/commission_result.dart';
import '../models/transaction.dart';
import 'currency_service.dart';

class CommissionRules {
  static const double depositRate = 0.0003; 
  static const double privateWithdrawRate = 0.003; 
  static const double businessWithdrawRate = 0.005; 
  static const double privateFreeLimitEur = 1000;
  static const int privateFreeWithdrawalsCount = 3;
}

class CommissionService {
  CommissionService(this._currencyService);

  final CurrencyService _currencyService;

  List<CommissionResult> calculateCommissions(List<Transaction> transactions) {
    final results = <CommissionResult>[];
    final privateUserWeeklyState = <String, _PrivateUserWeekState>{};

    for (var i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];
      final result = _calculateSingleCommission(
        transaction,
        i + 1,
        privateUserWeeklyState,
      );
      results.add(result);
    }

    return results;
  }

  CommissionResult _calculateSingleCommission(
    Transaction transaction,
    int index,
    Map<String, _PrivateUserWeekState> privateUserState,
  ) {
    final amountEur = _currencyService.convertToEur(
      transaction.amount,
      transaction.currency,
    );

    if (transaction.isDeposit) {
      return _calculateDepositCommission(transaction, amountEur, index);
    }

    if (transaction.isWithdraw) {
      if (transaction.isBusinessUser) {
        return _calculateBusinessWithdrawCommission(
          transaction,
          amountEur,
          index,
        );
      }
      if (transaction.isPrivateUser) {
        return _calculatePrivateWithdrawCommission(
          transaction,
          amountEur,
          index,
          privateUserState,
        );
      }
    }

    return CommissionResult(
      transactionIndex: index,
      description: 'Unknown operation',
      commission: 0,
      currency: 'EUR',
    );
  }

  CommissionResult _calculateDepositCommission(
    Transaction transaction,
    double amountEur,
    int index,
  ) {
    final commission = amountEur * CommissionRules.depositRate;
    final roundedCommission = _currencyService.roundUp(commission, 'EUR');

    return CommissionResult(
      transactionIndex: index,
      description: 'Deposit ${_formatAmount(transaction)} (${transaction.amount} x 0.03%)',
      commission: roundedCommission,
      currency: 'EUR',
      amountInEur: amountEur,
    );
  }

  CommissionResult _calculateBusinessWithdrawCommission(
    Transaction transaction,
    double amountEur,
    int index,
  ) {
    final commission = amountEur * CommissionRules.businessWithdrawRate;
    final roundedCommission = _currencyService.roundUp(commission, 'EUR');

    return CommissionResult(
      transactionIndex: index,
      description: 'Business withdraw ${_formatAmount(transaction)} (${transaction.amount} x 0.5%)',
      commission: roundedCommission,
      currency: 'EUR',
      amountInEur: amountEur,
    );
  }

  CommissionResult _calculatePrivateWithdrawCommission(
    Transaction transaction,
    double amountEur,
    int index,
    Map<String, _PrivateUserWeekState> stateMap,
  ) {
    final weekKey = _getWeekKey(transaction.date, transaction.userId);
    final state = stateMap.putIfAbsent(
      weekKey,
      () => _PrivateUserWeekState(),
    );

    state.withdrawalCount++;

    double commission;
    String description;

    if (state.withdrawalCount <= CommissionRules.privateFreeWithdrawalsCount) {
     
      final previousTotal = state.totalWithdrawn;
      state.totalWithdrawn += amountEur;

      if (state.withdrawalCount < CommissionRules.privateFreeWithdrawalsCount) {
        if (previousTotal < CommissionRules.privateFreeLimitEur &&
            state.totalWithdrawn > CommissionRules.privateFreeLimitEur) {
          state.deferredChargeable +=
              state.totalWithdrawn - CommissionRules.privateFreeLimitEur;
        } else if (previousTotal >= CommissionRules.privateFreeLimitEur) {
          state.deferredChargeable += amountEur;
        }
        commission = 0;
        description = state.totalWithdrawn <= CommissionRules.privateFreeLimitEur
            ? 'Withdraw ${_formatAmount(transaction)} Free'
            : 'Withdraw ${_formatAmount(transaction)} Limitli';
      } else {
        final chargeableAmount =
            (amountEur - state.deferredChargeable).clamp(0.0, amountEur);
        commission =
            chargeableAmount * CommissionRules.privateWithdrawRate;
        description = commission < 0.001
            ? 'Withdraw ${_formatAmount(transaction)} Free'
            : 'Withdraw ${_formatAmount(transaction)}Limitli';
      }
    } else {
      commission = amountEur * CommissionRules.privateWithdrawRate;
      description =
          'Withdraw ${_formatAmount(transaction)} (${state.withdrawalCount} no free';
    }

    final roundedCommission = _currencyService.roundUp(commission, 'EUR');

    return CommissionResult(
      transactionIndex: index,
      description: description,
      commission: roundedCommission,
      currency: 'EUR',
      amountInEur: amountEur,
      details: amountEur.toStringAsFixed(2),
    );
  }

  String _formatAmount(Transaction t) {
    if (t.currency == 'JPY') {
      final eur = _currencyService.convertToEur(t.amount, t.currency);
      return '${t.amount.toStringAsFixed(0)} ${t.currency} (~${eur.toStringAsFixed(2)} EUR)';
    }
    return '${t.amount.toStringAsFixed(2)} ${t.currency}';
  }

  String _getWeekKey(String dateStr, int userId) {
    final date = DateTime.parse(dateStr);
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '$userId-${monday.year}-${monday.month}-${monday.day}';
  }
}

class _PrivateUserWeekState {
  int withdrawalCount = 0;
  double totalWithdrawn = 0;
  double deferredChargeable = 0;
}

import 'package:flutter_test/flutter_test.dart';

import 'package:commession_app/core/models/transaction.dart';
import 'package:commession_app/core/services/commission_service.dart';
import 'package:commession_app/core/services/currency_service.dart';

void main() {
  late CommissionService commissionService;

  setUp(() {
    commissionService = CommissionService(CurrencyService());
  });

  group('CommissionService', () {
    test('deposit əməliyyatı üçün 0.03% komissiya hesablanır', () {
      final transactions = [
        const Transaction(
          date: '2024-01-02',
          userId: 1,
          userType: 'private',
          operationType: 'deposit',
          amount: 200,
          currency: 'EUR',
        ),
      ];

      final results = commissionService.calculateCommissions(transactions);

      expect(results.length, 1);
      expect(results.first.commission, 0.06);
      expect(results.first.currency, 'EUR');
    });

    test('business withdraw üçün 0.5% komissiya hesablanır', () {
      final transactions = [
        const Transaction(
          date: '2024-01-06',
          userId: 2,
          userType: 'business',
          operationType: 'withdraw',
          amount: 300,
          currency: 'EUR',
        ),
      ];

      final results = commissionService.calculateCommissions(transactions);

      expect(results.length, 1);
      expect(results.first.commission, 1.50);
      expect(results.first.currency, 'EUR');
    });

    test('çoxlu əməliyyatlar düzgün ardıcıllıqla işlənir', () {
      final transactions = [
        const Transaction(
          date: '2024-01-02',
          userId: 1,
          userType: 'private',
          operationType: 'deposit',
          amount: 200,
          currency: 'EUR',
        ),
        const Transaction(
          date: '2024-01-06',
          userId: 2,
          userType: 'business',
          operationType: 'withdraw',
          amount: 300,
          currency: 'EUR',
        ),
      ];

      final results = commissionService.calculateCommissions(transactions);

      expect(results.length, 2);
      expect(results[0].commission, 0.06);
      expect(results[0].transactionIndex, 1);
      expect(results[1].commission, 1.50);
      expect(results[1].transactionIndex, 2);
    });

    test('task-dakı nümunə məlumat üçün gözlənilən nəticələr', () {
      final transactions = [
        const Transaction(
          date: '2024-01-02',
          userId: 1,
          userType: 'private',
          operationType: 'deposit',
          amount: 200,
          currency: 'EUR',
        ),
        const Transaction(
          date: '2024-01-03',
          userId: 1,
          userType: 'private',
          operationType: 'withdraw',
          amount: 1000,
          currency: 'EUR',
        ),
        const Transaction(
          date: '2024-01-06',
          userId: 2,
          userType: 'business',
          operationType: 'withdraw',
          amount: 300,
          currency: 'EUR',
        ),
        const Transaction(
          date: '2024-01-06',
          userId: 1,
          userType: 'private',
          operationType: 'withdraw',
          amount: 30000,
          currency: 'JPY',
        ),
        const Transaction(
          date: '2024-01-07',
          userId: 1,
          userType: 'private',
          operationType: 'withdraw',
          amount: 1000,
          currency: 'EUR',
        ),
        const Transaction(
          date: '2024-01-07',
          userId: 1,
          userType: 'private',
          operationType: 'withdraw',
          amount: 100,
          currency: 'USD',
        ),
      ];

      final results = commissionService.calculateCommissions(transactions);

      expect(results.length, 6);
      expect(results[0].commission, 0.06); // Deposit 200 EUR
      expect(results[1].commission, 0.00); // Withdraw 1000 EUR (within limit)
      expect(results[2].commission, 1.50); // Business withdraw 300 EUR
      expect(results[3].commission, 0.00); // Withdraw 30000 JPY (within limit)
      expect(results[4].commission, 2.31); // Withdraw 1000 EUR (exceeded)
      expect(results[5].commission, 0.27); // Withdraw 100 USD (4th)
    });
  });
}

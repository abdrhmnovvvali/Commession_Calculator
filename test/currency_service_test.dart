import 'package:flutter_test/flutter_test.dart';

import 'package:commession_app/core/services/currency_service.dart';

void main() {
  late CurrencyService currencyService;

  setUp(() {
    currencyService = CurrencyService();
  });

  group('CurrencyService', () {
    test('EUR məbləği dəyişməz qalır', () {
      expect(currencyService.convertToEur(100, 'EUR'), 100);
    });

    test('USD-dən EUR-a düzgün çevrilir', () {
      final eur = currencyService.convertToEur(114.97, 'USD');
      expect(eur, closeTo(100, 0.01));
    });

    test('JPY-dən EUR-a düzgün çevrilir', () {
      final eur = currencyService.convertToEur(12953, 'JPY');
      expect(eur, closeTo(100, 0.01));
    });

    test('roundUp EUR üçün 2 onluq yuvarlaqlaşdırır', () {
      expect(currencyService.roundUp(0.023, 'EUR'), 0.03);
      expect(currencyService.roundUp(0.021, 'EUR'), 0.03);
      expect(currencyService.roundUp(0.02, 'EUR'), 0.02);
    });

    test('roundUp JPY üçün tam ədəd qaytarır', () {
      expect(currencyService.roundUp(100.4, 'JPY'), 101);
      expect(currencyService.roundUp(100.0, 'JPY'), 100);
    });
  });
}

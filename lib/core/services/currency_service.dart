import 'dart:math';

import '../constants/currency_config.dart';

class CurrencyService {
  double convertToEur(double amount, String currency) {
    final config = CurrencyConfig.getConfig(currency);
    return amount / config.rateToEur;
  }

  double roundUp(double amount, String currency) {
    final config = CurrencyConfig.getConfig(currency);
    final multiplier = pow(10, config.precision);
    return (amount * multiplier).ceil() / multiplier;
  }

  String formatAmount(double amount, String currency) {
    final config = CurrencyConfig.getConfig(currency);
    if (config.precision == 0) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(config.precision);
  }
}

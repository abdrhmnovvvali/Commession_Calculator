class CurrencyConfig {
  const CurrencyConfig({
    required this.rateToEur,
    required this.precision,
  });

  final double rateToEur;
  final int precision;

  static const eur = CurrencyConfig(rateToEur: 1.0, precision: 2);
  static const usd = CurrencyConfig(rateToEur: 1.1497, precision: 2);
  static const jpy = CurrencyConfig(rateToEur: 129.53, precision: 0);

  static CurrencyConfig getConfig(String currency) {
    switch (currency.toUpperCase()) {
      case 'EUR':
        return eur;
      case 'USD':
        return usd;
      case 'JPY':
        return jpy;
      default:
        return eur;
    }
  }
}

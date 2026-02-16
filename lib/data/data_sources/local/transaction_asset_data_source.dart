import 'package:flutter/services.dart';

class TransactionAssetDataSource {
  static const String _defaultAssetPath = 'assets/transactions.json';

  Future<String> loadTransactionsJson({String assetPath = _defaultAssetPath}) async {
    return rootBundle.loadString(assetPath);
  }
}

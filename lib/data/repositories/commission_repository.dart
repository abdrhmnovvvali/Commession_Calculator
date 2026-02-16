import 'dart:convert';

import '../../core/models/commission_result.dart';
import '../../core/models/transaction.dart';
import '../../core/services/commission_service.dart';
import '../contracts/commission_contract.dart';
import '../data_sources/local/transaction_asset_data_source.dart';
import '../models/commission_calculation_result.dart';

class CommissionRepository implements CommissionContract {
  CommissionRepository(
    this._transactionDataSource,
    this._commissionService,
  );

  final TransactionAssetDataSource _transactionDataSource;
  final CommissionService _commissionService;

  @override
  Future<CommissionCalculationResult> loadAndCalculateFromAssets() async {
    final jsonString = await _transactionDataSource.loadTransactionsJson();
    return calculateFromJson(jsonString);
  }

  @override
  Future<CommissionCalculationResult> calculateFromJson(String jsonString) async {
    final List<dynamic> jsonList = json.decode(jsonString);
    final transactions = jsonList
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();

    final results = _commissionService.calculateCommissions(transactions);

    return CommissionCalculationResult(
      transactions: transactions,
      results: results,
    );
  }
}

import '../models/commission_calculation_result.dart';

abstract class CommissionContract {
  Future<CommissionCalculationResult> loadAndCalculateFromAssets();

  Future<CommissionCalculationResult> calculateFromJson(String jsonString);
}

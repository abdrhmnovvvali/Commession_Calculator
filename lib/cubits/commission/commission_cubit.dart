import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/contracts/commission_contract.dart';
import '../../core/models/commission_result.dart';
import '../../core/models/transaction.dart';

part 'commission_state.dart';

class CommissionCubit extends Cubit<CommissionState> {
  CommissionCubit(this._commissionContract) : super(CommissionInitial());

  final CommissionContract _commissionContract;

  Future<void> loadAndCalculateFromAssets() async {
    emit(CommissionLoading());

    try {
      final result = await _commissionContract.loadAndCalculateFromAssets();
      emit(CommissionSuccess(results: result.results, transactions: result.transactions));
    } catch (e) {
      emit(CommissionFailure('Fayl xetasi $e'));
    }
  }

  Future<void> calculateFromJson(String jsonString) async {
    emit(CommissionLoading());

    try {
      final result = await _commissionContract.calculateFromJson(jsonString);
      emit(CommissionSuccess(results: result.results, transactions: result.transactions));
    } catch (e) {
      emit(CommissionFailure('Json format xetasi $e'));
    }
  }

  void reset() {
    emit(CommissionInitial());
  }
}

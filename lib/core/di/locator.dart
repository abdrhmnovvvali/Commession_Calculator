import '../services/commission_service.dart';
import '../services/currency_service.dart';
import '../../cubits/commission/commission_cubit.dart';
import '../../data/contracts/commission_contract.dart';
import '../../data/data_sources/local/transaction_asset_data_source.dart';
import '../../data/repositories/commission_repository.dart';
import 'base_locator.dart';

final locator = BaseLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CurrencyService());
  locator.registerLazySingleton(
    () => CommissionService(locator<CurrencyService>()),
  );

  locator.registerLazySingleton(() => TransactionAssetDataSource());

  locator.registerLazySingleton<CommissionContract>(
    () => CommissionRepository(
      locator<TransactionAssetDataSource>(),
      locator<CommissionService>(),
    ),
  );

  locator.registerFactory(
    () => CommissionCubit(locator<CommissionContract>()),
  );
}

class BaseLocator {
  BaseLocator._();

  static final BaseLocator _instance = BaseLocator._();
  static BaseLocator get instance => _instance;

  final Map<Type, dynamic> _singletonInstances = {};
  final Map<Type, Function> _factories = {};

  void registerSingleton<T>(T instance) {
    _singletonInstances[T] = instance;
  }

  void registerLazySingleton<T>(T Function() factory) {
    _factories[T] = () {
      if (!_singletonInstances.containsKey(T)) {
        _singletonInstances[T] = factory();
      }
      return _singletonInstances[T];
    };
  }

  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  T call<T>() {
    if (_singletonInstances.containsKey(T)) {
      return _singletonInstances[T] as T;
    }
    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }
    throw Exception('Service of type $T is not registered');
  }
}

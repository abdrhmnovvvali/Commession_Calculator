# Commission Calculator

Flutter ilə hazırlanmış komissiya hesablama tətbiqi. Maliyyə əməliyyatlarını emal edir və konfiqurasiya olunan qaydalara əsasən komissiyaları hesablayır.

## Arxitektura

Tətbiq **gringo** layihəsinin strukturuna uyğun qurulub:

- **Cubit** – state management (flutter_bloc)
- **Layered Architecture** – core (models, services), cubits, presentation
- **SOLID prinsipləri** – xidmətlər ayrıca, test oluna bilən

### Layihə strukturu

```
lib/
├── core/
│   ├── constants/     # Valyuta konfiqurasiyası
│   ├── models/       # Transaction, CommissionResult
│   └── services/     # CurrencyService, CommissionService
├── cubits/
│   └── commission/   # CommissionCubit, CommissionState
├── presentation/
│   └── pages/        # CommissionPage
└── main.dart
```

## Komissiya qaydaları

- **Depozit**: 0.03% (bütün istifadəçilər)
- **Çıxarış (Private)**: 0.3%, həftədə ilk 3 çıxarış 1000 EUR-a qədər pulsuz
- **Çıxarış (Business)**: 0.5%, pulsuz limit yoxdur

## Valyuta dəstəyi

| Valyuta | Məzənnə (EUR-a) | Dəqiqlik |
|---------|-----------------|----------|
| EUR     | 1.0             | 2        |
| USD     | 1.1497          | 2        |
| JPY     | 129.53          | 0        |

## Quraşdırma və işə salma

```bash
cd commession_app
flutter pub get
flutter run
```

## Testlər

```bash
flutter test
```

## Fərziyyələr

- Həftə bazar ertəsi günü başlayır
- Məzənnələr sabit (hardcoded)
- Input JSON formatında
- Bütün komissiyalar EUR ilə göstərilir

## Vaxt

Təxmini vaxt: 3–4 saat

import 'package:flutter_test/flutter_test.dart';

import 'package:commession_app/core/di/locator.dart';
import 'package:commession_app/main.dart';

void main() {
  setUp(() {
    setupLocator();
  });

  testWidgets('CommissionCalculator başlanğıcda düymə göstərir',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CommissionApp());

    expect(find.text('Əməliyyatları Yüklə'), findsOneWidget);
  });
}

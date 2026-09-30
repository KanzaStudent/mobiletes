import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latkuis/main.dart';

void main() {
  testWidgets('login demo membuka aplikasi dengan kredensial yang benar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('menu dapat difavoritkan dan pengguna dapat logout', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'admin123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tambahkan ke favorit').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorit'));
    await tester.pumpAndSettle();

    expect(find.text('Menu Favorit'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Menu Resto'), findsOneWidget);
  });
}

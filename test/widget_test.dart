import 'package:dupouy_sibe_nathalie/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('opens settings from the operations shell', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      OperationsApp(store: OperationsStore(screenshotMode: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text(appName), findsOneWidget);

    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();

    expect(find.text('Workspace'), findsOneWidget);
    expect(find.text('No account registration'), findsOneWidget);
  });

  testWidgets('creates a procurement request locally', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      OperationsApp(store: OperationsStore(screenshotMode: false)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addRecordButton')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Printer supplies',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Office lead');
    await tester.enterText(find.byType(TextFormField).at(2), '340');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'Buy toner and labels.',
    );
    await tester.ensureVisible(find.byKey(const Key('saveRecordButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveRecordButton')));
    await tester.pumpAndSettle();

    expect(find.text('Printer supplies'), findsOneWidget);
    expect(find.text('Office lead'), findsOneWidget);
  });
}

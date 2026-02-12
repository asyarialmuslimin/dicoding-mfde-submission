import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TV Series Integration Test', () {
    testWidgets('tap on tv series item should navigate to detail page',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap TV Series tab in BottomNavigationBar
      final tvSeriesTab = find.text('TV Series');
      expect(tvSeriesTab, findsOneWidget);
      await tester.tap(tvSeriesTab);
      await tester.pumpAndSettle();

      // Find a TV Series Card (InkWell inside TVSeriesCard)
      // Since it's a real app, we wait for data to load.
      // We might need to wait for the ListView or a specific text.
      final tvSeriesItem = find.byType(InkWell).first;
      await tester.tap(tvSeriesItem);
      await tester.pumpAndSettle();

      // Verify we are on the Detail Page
      // In TVSeriesDetailPage, we have "Watchlist" button
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Tap Watchlist button
      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();

      // Check for SnackBar or Dialog (since it's a real app, it depends on state)
      // In the unit test we saw it can show SnackBar or AlertDialog
      // We can check if either is present
      final snackBar = find.byType(SnackBar);
      final alertDialog = find.byType(AlertDialog);

      expect(
        find
                .descendant(
                  of: find.byType(ScaffoldMessenger),
                  matching: snackBar,
                )
                .evaluate()
                .isNotEmpty ||
            alertDialog.evaluate().isNotEmpty,
        true,
      );
    });
  });
}

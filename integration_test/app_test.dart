import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storehub/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('StoreHub App Integration Tests', () {
    testWidgets('should load home screen and display products', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify splash screen appears first
      expect(find.text('StoreHub'), findsOneWidget);

      // Wait for navigation to home screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen elements
      expect(find.text('Search products...'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('ALL PRODUCTS'), findsOneWidget);
    });

    testWidgets('should navigate to search screen and search products',
            (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Wait for home screen
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Tap on search bar
          await tester.tap(find.text('Search products...'));
          await tester.pumpAndSettle();

          // Verify search screen
          expect(find.text('Search Products'), findsOneWidget);
          expect(find.text('Search for products...'), findsOneWidget);

          // Type in search field
          await tester.enterText(find.byType(TextField), 'shirt');
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify either results or loading indicator
          final hasProgress = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
          final hasResults = find.textContaining('results for').evaluate().isNotEmpty;

          expect(
            hasProgress || hasResults,
            true,
            reason: 'Expected either a loading spinner or search results',
          );
        });

    testWidgets('should navigate between bottom navigation tabs',
            (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Wait for home screen
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Verify bottom navigation bar exists
          expect(find.text('Home'), findsOneWidget);
          expect(find.text('Search'), findsOneWidget);
          expect(find.text('Categories'), findsOneWidget);

          // Tap on Categories tab
          await tester.tap(find.text('Categories'));
          await tester.pumpAndSettle();

          // Verify categories screen loads
          expect(find.text('Categories'), findsOneWidget);

          // Go back to Home
          await tester.tap(find.text('Home'));
          await tester.pumpAndSettle();

          // Verify back on home screen
          expect(find.text('ALL PRODUCTS'), findsOneWidget);
        });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:storehub/presentation/home_screen/widgets/search_bar_widget.dart';

Widget wrapWithSizer(Widget child) {
  return Sizer(
    builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(body: child),
      );
    },
  );
}

void main() {
  group('SearchBarWidget', () {
    testWidgets('should render search bar with hint text', (tester) async {
      const hintText = 'Search products...';
      var tapped = false;

      await tester.pumpWidget(
        wrapWithSizer(
          SearchBarWidget(
            hintText: hintText,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text(hintText), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapWithSizer(
          SearchBarWidget(
            hintText: 'Search...',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(SearchBarWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(
        wrapWithSizer(
          SearchBarWidget(
            hintText: 'Search...',
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}

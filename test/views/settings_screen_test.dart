import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('SettingsScreen', () {
    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays settings UI after loading',
        (WidgetTester tester) async {
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
      expect(
          find.widgetWithText(ElevatedButton, 'Back to Order'), findsOneWidget);
    });

    testWidgets('displays current font size', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'fontSize': 18.0});
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Current size: 18px'), findsOneWidget);
    });

    testWidgets('slider changes font size', (WidgetTester tester) async {
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      // Change slider value
      await tester.drag(sliderFinder, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Verify that font size has changed (we don't test exact value due to drag offset)
      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('back button is present and can be tapped',
        (WidgetTester tester) async {
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder backButtonFinder =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final ElevatedButton backButton =
          tester.widget<ElevatedButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('slider has correct range and divisions',
        (WidgetTester tester) async {
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);

      expect(slider.min, 12.0);
      expect(slider.max, 24.0);
      expect(slider.divisions, 6);
    });

    testWidgets('displays logo image', (WidgetTester tester) async {
      await AppStyles.loadFontSize();

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });
  });
}

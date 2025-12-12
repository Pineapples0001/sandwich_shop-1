import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppStyles', () {
    test('loadFontSize loads default font size when no saved value', () async {
      await AppStyles.loadFontSize();
      expect(AppStyles.baseFontSize, 16.0);
    });

    test('loadFontSize loads saved font size from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'fontSize': 20.0});
      await AppStyles.loadFontSize();
      expect(AppStyles.baseFontSize, 20.0);
    });

    test('saveFontSize saves font size to SharedPreferences', () async {
      await AppStyles.saveFontSize(18.0);
      expect(AppStyles.baseFontSize, 18.0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('fontSize'), 18.0);
    });

    test('saveFontSize updates baseFontSize', () async {
      await AppStyles.saveFontSize(22.0);
      expect(AppStyles.baseFontSize, 22.0);

      await AppStyles.saveFontSize(14.0);
      expect(AppStyles.baseFontSize, 14.0);
    });

    test('normalText returns TextStyle with baseFontSize', () async {
      await AppStyles.saveFontSize(16.0);
      final style = AppStyles.normalText;
      expect(style.fontSize, 16.0);
    });

    test('heading1 returns TextStyle with correct size and weight', () async {
      await AppStyles.saveFontSize(16.0);
      final style = AppStyles.heading1;
      expect(style.fontSize, 24.0); // baseFontSize + 8
      expect(style.fontWeight, FontWeight.bold);
    });

    test('heading2 returns TextStyle with correct size and weight', () async {
      await AppStyles.saveFontSize(16.0);
      final style = AppStyles.heading2;
      expect(style.fontSize, 20.0); // baseFontSize + 4
      expect(style.fontWeight, FontWeight.bold);
    });

    test('global normalText getter returns AppStyles.normalText', () async {
      await AppStyles.saveFontSize(18.0);
      final style = normalText;
      expect(style.fontSize, 18.0);
    });

    test('global heading1 getter returns AppStyles.heading1', () async {
      await AppStyles.saveFontSize(16.0);
      final style = heading1;
      expect(style.fontSize, 24.0);
      expect(style.fontWeight, FontWeight.bold);
    });

    test('global heading2 getter returns AppStyles.heading2', () async {
      await AppStyles.saveFontSize(16.0);
      final style = heading2;
      expect(style.fontSize, 20.0);
      expect(style.fontWeight, FontWeight.bold);
    });

    test('font sizes change dynamically when baseFontSize changes', () async {
      await AppStyles.saveFontSize(16.0);
      expect(AppStyles.heading1.fontSize, 24.0);
      expect(AppStyles.heading2.fontSize, 20.0);

      await AppStyles.saveFontSize(20.0);
      expect(AppStyles.heading1.fontSize, 28.0);
      expect(AppStyles.heading2.fontSize, 24.0);
    });
  });
}

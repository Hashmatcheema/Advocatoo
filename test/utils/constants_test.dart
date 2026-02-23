import 'package:advocatoo/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConstants', () {
    test('date format pattern is DD/MM/YYYY', () {
      expect(AppConstants.dateFormatPattern, 'dd/MM/yyyy');
    });
    test('time format 12h pattern has AM/PM', () {
      expect(AppConstants.timeFormat12hPattern, 'hh:mm a');
    });
    test('reminder time is 07:00', () {
      expect(AppConstants.reminderHour, 7);
      expect(AppConstants.reminderMinute, 0);
    });
    test('large text scale factor is 1.2 (20% increase)', () {
      expect(AppConstants.largeTextScaleFactor, 1.2);
    });
    test('SharedPreferences keys are defined', () {
      expect(AppConstants.keyThemeMode, 'theme_mode');
      expect(AppConstants.keyLargeText, 'large_text_enabled');
    });
  });
}

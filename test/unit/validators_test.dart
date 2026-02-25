import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/utils/validators.dart';

void main() {
  // ── Case Title ──────────────────────────────────────────────────────────

  group('validateCaseTitle', () {
    test('null input returns error', () {
      expect(validateCaseTitle(null), isNotNull);
    });

    test('empty string returns error', () {
      expect(validateCaseTitle(''), isNotNull);
    });

    test('whitespace-only returns error', () {
      expect(validateCaseTitle('   '), isNotNull);
    });

    test('non-empty title returns null (valid)', () {
      expect(validateCaseTitle('State vs. Imran Khan'), isNull);
    });

    test('single character is valid', () {
      expect(validateCaseTitle('X'), isNull);
    });
  });

  // ── Client Phone ────────────────────────────────────────────────────────

  group('validateClientPhone', () {
    test('empty is allowed (field is optional)', () {
      expect(validateClientPhone(''), isNull);
    });

    test('null is allowed', () {
      expect(validateClientPhone(null), isNull);
    });

    test('03XX-XXXXXXX format (with dash) is valid', () {
      expect(validateClientPhone('0300-1234567'), isNull);
    });

    test('11-digit 03XXXXXXXXX (no dash) is valid', () {
      expect(validateClientPhone('03001234567'), isNull);
    });

    test('+923XXXXXXXXX international format is valid', () {
      expect(validateClientPhone('+923001234567'), isNull);
    });

    test('random letters returns error', () {
      expect(validateClientPhone('abc-defghij'), isNotNull);
    });

    test('landline number (04X) returns error', () {
      expect(validateClientPhone('04211234567'), isNotNull);
    });

    test('too short returns error', () {
      expect(validateClientPhone('0300-123'), isNotNull);
    });

    test('too long returns error', () {
      expect(validateClientPhone('030012345678901'), isNotNull);
    });
  });

  // ── CNIC ────────────────────────────────────────────────────────────────

  group('validateCnic', () {
    test('empty is allowed (field is optional)', () {
      expect(validateCnic(''), isNull);
    });

    test('null is allowed', () {
      expect(validateCnic(null), isNull);
    });

    test('XXXXX-XXXXXXX-X format is valid', () {
      expect(validateCnic('35202-1234567-1'), isNull);
    });

    test('missing dashes returns error', () {
      expect(validateCnic('3520212345671'), isNotNull);
    });

    test('wrong segment lengths returns error', () {
      expect(validateCnic('352-1234567-1'), isNotNull);
    });

    test('letters in number returns error', () {
      expect(validateCnic('3520A-1234567-1'), isNotNull);
    });

    test('correct format with different valid values', () {
      expect(validateCnic('42101-9876543-2'), isNull);
    });
  });
}

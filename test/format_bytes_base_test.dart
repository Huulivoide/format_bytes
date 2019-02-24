import 'dart:math';
import 'package:test/test.dart';
import 'package:format_bytes/src/format_bytes_base.dart';
import 'package:format_bytes/src/units.dart';

void main() {
  group('Format', () {
    group('Handle Error Conditions', () {
      test('should not allow null as the amount param', () {
        expect(
            () => format(null),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher((ArgumentError it) => (it.name == 'amount')))
            ]));
      });

      test('should not allow null as the locale param', () {
        expect(
            () => format(1024, locale: null),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher((ArgumentError it) => (it.name == 'locale')))
            ]));
      });

      test('should not allow null as the formatString param', () {
        expect(
            () => format(1024, formatString: null),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher(
                  (ArgumentError it) => (it.name == 'formatString')))
            ]));
      });

      test('should not allow null as the separator param', () {
        expect(
            () => format(1024, separator: null),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'separator')))
            ]));
      });

      test('should not allow null as the minDecimals param', () {
        expect(
            () => format(1024, minDecimals: null),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'minDecimals')))
            ]));
      });

      test('should not allow null as the maxDecimals param', () {
        expect(
            () => format(1024, maxDecimals: null),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'maxDecimals')))
            ]));
      });

      test('should not allow null as the maxPrecision param', () {
        expect(
            () => format(1024, maxPrecision: null),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher(
                  (ArgumentError it) => (it.name == 'maxPrecision')))
            ]));
      });

      test('should not allow null as the unit param', () {
        expect(
            () => format(1024, unit: null),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher((ArgumentError it) => (it.name == 'unit')))
            ]));
      });

      test('should not allow null as the unitType param', () {
        expect(
            () => format(1024, unitType: null),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'unitType')))
            ]));
      });

      test('should not allow negative value for minDecimals', () {
        expect(
            () => format(1024, minDecimals: -1),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'minDecimals')))
            ]));
      });

      test('should not allow negative value for maxDecimals', () {
        expect(
            () => format(1024, maxDecimals: -1),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'maxDecimals')))
            ]));
      });

      test('should not allow maxDecimals value that is less than minDecimals',
          () {
        expect(
            () => format(1024, maxDecimals: 1, minDecimals: 2),
            allOf([
              throwsArgumentError,
              throwsA(
                  wrapMatcher((ArgumentError it) => (it.name == 'maxDecimals')))
            ]));
      });

      test('should not allow negative value (other than -1) for maxPrecision',
          () {
        expect(
            () => format(1024, maxPrecision: -2),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher(
                  (ArgumentError it) => (it.name == 'maxPrecision')))
            ]));
      });

      test('should not allow 0 as a value for maxPrecision', () {
        expect(
            () => format(1024, maxPrecision: 0),
            allOf([
              throwsArgumentError,
              throwsA(wrapMatcher(
                  (ArgumentError it) => (it.name == 'maxPrecision')))
            ]));
      });
    });

    group('Handle Good Paramaters', () {
      group('Amount', () {
        test('should format 0 bytes', () {
          expect(format(0), '0 B');
        });

        test('should format -0 bytes', () {
          expect(format(-0.0), '-0 B');
        });

        test('should format 1023 bytes', () {
          expect(format(1023), '1,023 B');
        });

        test('should format 1KiB', () {
          expect(format(1024), '1 KiB');
        });

        test('should format 1MiB', () {
          expect(format(pow(1024, 2)), '1 MiB');
        });

        test('should format 1GiB', () {
          expect(format(pow(1024, 3)), '1 GiB');
        });

        test('should format 1TiB', () {
          expect(format(pow(1024, 4)), '1 TiB');
        });

        test('should format 1PiB', () {
          expect(format(pow(1024, 5)), '1 PiB');
        });

        test('should format 1EiB', () {
          expect(format(pow(1024, 6)), '1 EiB');
        });

        test('should format 1ZiB', () {
          expect(format(pow(1024.0, 7)), '1 ZiB');
        });

        test('should format 1YiB', () {
          expect(format(pow(1024.0, 8)), '1 YiB');
        });
      });

      group('Locale', () {
        test('should use requested locale', () {
          expect(format(1024, locale: 'ru'), '1 КиБ');
        });
      });

      group('FormatString', () {
        test('should replace %amount', () {
          expect(format(1024, formatString: '%amount'), '1');
        });

        test('should replace %sep', () {
          expect(format(1024, formatString: '%sep'), ' ');
        });

        test('should replace %unit', () {
          expect(format(1024, formatString: '%unit'), 'KiB');
        });

        test('should not touch other stuff', () {
          expect(format(1024, formatString: '%amount first %sep second %unit'),
              '1 first   second KiB');
        });
      });

      group('Separator', () {
        test('should use provided custom separator', () {
          expect(format(1024, separator: '😁'), '1😁KiB');
        });
      });

      group('CustomAmountTransformer', () {
        test('should use provided transformer', () {
          expect(format(1024, customAmountTransformer: (b) => 'custom'),
              'custom KiB');
        });
      });

      group('MinDecimals', () {
        test('should include unneeded decimals if > 0', () {
          expect(format(1024, minDecimals: 2), '1.00 KiB');
        });
      });

      group('MaxDecimals', () {
        test('should cut off all decimals if 0', () {
          expect(format(1500, maxDecimals: 0), '1 KiB');
        });
      });

      group('MaxPrecission', () {
        test('should limit to intgers only', () {
          expect(format(1024 * 123, maxPrecision: 1), '100 KiB');
        });

        test('should limit decimals', () {
          expect(format(1024 * 1.25, maxPrecision: 2), '1.3 KiB');
        });
      });

      group('Unit', () {
        test('should use provided unit', () {
          expect(format((1024 * 1024) / 2, unit: Unit.mebibyte), '0.5 MiB');
        });

        test('should use provided custom unit', () {
          expect(
              format(500, unit: Unit('custom', 10, UnitType.decimal)), '50 ');
        });
      });

      group('UnitType', () {
        test('should use binary units', () {
          expect(format(1024, unitType: UnitType.binary), '1 KiB');
        });

        test('should use decimal units', () {
          expect(format(1000, unitType: UnitType.decimal), '1 KB');
        });
      });
    });
  });
}

import 'dart:math';
import 'package:test/test.dart';
import 'package:format_bytes/src/units.dart';

void main() {
  group('Units', () {
    group('find(String byName)', () {
      test('should find megabyte', () {
        var unit = Unit.find('megabyte');
        expect(unit, Unit.megabyte);
      });

      test('should find pebibyte', () {
        var unit = Unit.find('pebibyte');
        expect(unit, Unit.pebibyte);
      });

      test('should not find auto', () {
        expect(() => Unit.find('auto'), throwsArgumentError);
      });

      test('should not find null', () {
        expect(() => Unit.find(null), throwsArgumentError);
      });
    });

    group('getBest(String for)', () {
      group('Error Conditions', () {
        test('should throw if amount is nonfinite ∞', () {
          expect(() => Unit.bestFor(double.infinity), throwsArgumentError);
        });

        test('should throw if amount is nonfinite -∞', () {
          expect(
              () => Unit.bestFor(double.negativeInfinity), throwsArgumentError);
        });

        test('should throw if amount is NaN', () {
          expect(() => Unit.bestFor(double.nan), throwsArgumentError);
        });
      });

      group('Decimal units', () {
        test('shoud get byte for 0', () {
          var unit = Unit.bestFor(0, UnitType.decimal);
          expect(unit, Unit.byte);
        });

        test('shoud get byte for -0', () {
          var unit = Unit.bestFor(-0, UnitType.decimal);
          expect(unit, Unit.byte);
        });

        const double base = 1000;

        [
          Unit.byte,
          Unit.kilobyte,
          Unit.megabyte,
          Unit.gigabyte,
          Unit.terabyte,
          Unit.petabyte,
          Unit.exabyte,
          Unit.zettabyte,
          Unit.yottabyte
        ].asMap().forEach((i, expectedUnit) {
          test('should return ${expectedUnit.name} for ${base.toInt()}^$i', () {
            var unit = Unit.bestFor(pow(base, i), UnitType.decimal);
            expect(unit.name, expectedUnit.name);
          });
        });
      });

      group('Decimal units', () {
        test('shoud get byte for 0', () {
          var unit = Unit.bestFor(0, UnitType.binary);
          expect(unit, Unit.byte);
        });

        test('shoud get byte for -0', () {
          var unit = Unit.bestFor(-0, UnitType.binary);
          expect(unit, Unit.byte);
        });

        const double base = 1024;

        [
          Unit.byte,
          Unit.kibibyte,
          Unit.mebibyte,
          Unit.gibibyte,
          Unit.tebibyte,
          Unit.pebibyte,
          Unit.exbibyte,
          Unit.zebibyte,
          Unit.yobibyte
        ].asMap().forEach((i, expectedUnit) {
          test('should return ${expectedUnit.name} for ${base.toInt()}^$i', () {
            var unit = Unit.bestFor(pow(base, i), UnitType.binary);
            expect(unit.name, expectedUnit.name);
          });
        });
      });
    });
  });
}

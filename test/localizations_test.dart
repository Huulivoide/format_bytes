import 'package:test/test.dart';
import 'package:format_bytes/src/units.dart';
import 'package:format_bytes/src/localizations.dart';

void main() {
  group('Get Localization', () {
    test('should get real existing one (ru)', () {
      var localization = getLocalization('ru');

      expect(localization, TypeMatcher<Localization>());
      expect(localization.units, containsPair(Unit.mebibyte, 'МиБ'));
    });

    test('should fallback to general version ru-ru → ru', () {
      expect(getLocalization('ru-ru'), getLocalization('ru'));
    });

    test('should fallback to english if requested locale is not found', () {
      expect(getLocalization('non-locale'), getLocalization('en'));
    });
  });
}

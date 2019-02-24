import 'units.dart';

class Localization {
  final String format;
  final String separator;
  final Map<Unit, String> units;

  const Localization(this.format, this.separator, this.units);
}

const _localizedUnits = {
  'en': Localization('%amount%sep%unit', ' ', {
    Unit.byte: 'B',
    Unit.kilobyte: 'KB',
    Unit.megabyte: 'MB',
    Unit.gigabyte: 'GB',
    Unit.terabyte: 'TB',
    Unit.petabyte: 'PB',
    Unit.exabyte: 'EB',
    Unit.zettabyte: 'ZB',
    Unit.yottabyte: 'YB',
    Unit.kibibyte: 'KiB',
    Unit.mebibyte: 'MiB',
    Unit.gibibyte: 'GiB',
    Unit.tebibyte: 'TiB',
    Unit.pebibyte: 'PiB',
    Unit.exbibyte: 'EiB',
    Unit.zebibyte: 'ZiB',
    Unit.yobibyte: 'YiB'
  }),
  'fi': Localization('%amount%sep%unit', ' ', {
    Unit.byte: 't',
    Unit.kilobyte: 'Kt',
    Unit.megabyte: 'Mt',
    Unit.gigabyte: 'Gt',
    Unit.terabyte: 'Tt',
    Unit.petabyte: 'Pt',
    Unit.exabyte: 'Et',
    Unit.zettabyte: 'Zt',
    Unit.yottabyte: 'Yt',
    Unit.kibibyte: 'KiB',
    Unit.mebibyte: 'MiB',
    Unit.gibibyte: 'GiB',
    Unit.tebibyte: 'TiB',
    Unit.pebibyte: 'PiB',
    Unit.exbibyte: 'EiB',
    Unit.zebibyte: 'ZiB',
    Unit.yobibyte: 'YiB'
  }),
  'ru': Localization('%amount%sep%unit', ' ', {
    Unit.byte: 'б',
    Unit.kilobyte: 'Кб',
    Unit.megabyte: 'Мб',
    Unit.gigabyte: 'Гб',
    Unit.terabyte: 'Тб',
    Unit.petabyte: 'Пб',
    Unit.exabyte: 'Эб',
    Unit.zettabyte: 'Зб',
    Unit.yottabyte: 'Йб',
    Unit.kibibyte: 'КиБ',
    Unit.mebibyte: 'МиБ',
    Unit.gibibyte: 'ГиБ',
    Unit.tebibyte: 'ТиБ',
    Unit.pebibyte: 'ПиБ',
    Unit.exbibyte: 'ЭиБ',
    Unit.zebibyte: 'ЗиБ',
    Unit.yobibyte: 'ЙиБ'
  }),
};

Localization getLocalization(String locale) {
  if (_localizedUnits.containsKey(locale)) return _localizedUnits[locale];

  var primary = locale.split('-')[0];
  if (_localizedUnits.containsKey(primary)) return _localizedUnits[primary];

  return _localizedUnits['en'];
}

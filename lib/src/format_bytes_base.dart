import 'package:intl/intl.dart' show NumberFormat;
import 'units.dart';
import 'localizations.dart';

const defaultFormatString = 'locale default';
const defaultSeparator = defaultFormatString;

/// A function that transforms [double] to [String].
///
/// The build in [double.toString] can result in ouputs like 1.123e+24 which
/// might be unwanted.
typedef AmountToString = String Function(double amount);

/// Creates a [AmountToString] transformer with specified precision.
///
/// Creates a [NumberFormat] based transformer function.
///
/// ```
/// def fmt = createPrecisionFormatter(0, 0, 3, 'en-us');
/// print(fmt(123456.789)); // → '123000'
/// ```
///
/// [minDecimals] ans [maxDecimals] specifies the minimum and maximum amount of
/// decimal places included in the output. [maxPrecision] defines the maximum
/// significant digits included in the output. [maxPrecision] can be disabled
/// with -1. Finally [locale] can be used to control the number styling
/// and decimal separator.
///
/// Will throw [ArgumentError] if the following conditions are not met.
/// * 0 <= [minDecimals] <= [maxDecimals]
/// * [maxPrecision] == -1 or 1 <= [maxPrecision]
///
AmountToString createPrecisionFormatter(
    int minDecimals, int maxDecimals, int maxPrecision, String locale) {
  if (minDecimals < 0) {
    throw ArgumentError.value(
        minDecimals, 'minDecimals', 'Expected positive value.');
  }

  if (maxDecimals < 0 || maxDecimals < minDecimals) {
    throw ArgumentError.value(maxDecimals, 'maxDecimals',
        'Expected positive value larger or equal to minDecimals.');
  }

  if (maxPrecision < -1 || maxPrecision == 0) {
    throw ArgumentError.value(maxPrecision, 'maxPrecision',
        'Expected positive non zero value or -1 (no limit).');
  }

  var fmt = NumberFormat.decimalPattern(locale)
    ..minimumFractionDigits = minDecimals
    ..maximumFractionDigits = maxDecimals
    ..significantDigits = maxPrecision
    ..significantDigitsInUse = (maxPrecision > 0);

  return (double amount) {
    return fmt.format(amount);
  };
}

Unit _resolveRealUnit(double amount, Unit possibleUnit, UnitType type) {
  if (possibleUnit != Unit.auto) return possibleUnit;

  return Unit.bestFor(amount, type);
}

String _formatString(double amount, AmountToString amountToString,
    String format, String separator, String unit) {
  return format
      .replaceFirst('%amount', amountToString(amount))
      .replaceFirst('%sep', separator)
      .replaceFirst('%unit', unit);
}

String _formatSafeParams(
    num amount,
    String locale,
    String formatString,
    String separator,
    AmountToString customAmountTransformer,
    int minDecimals,
    int maxDecimals,
    int maxPrecision,
    Unit unit,
    UnitType unitType) {
  var doubleAmount = amount.toDouble();
  var amountToString = customAmountTransformer ??
      createPrecisionFormatter(minDecimals, maxDecimals, maxPrecision, locale);

  var realUnit = _resolveRealUnit(doubleAmount, unit, unitType);
  var localization = getLocalization(locale);

  return _formatString(
      doubleAmount / realUnit.multiplier,
      amountToString,
      (formatString == defaultFormatString)
          ? localization.format
          : formatString,
      (separator == defaultSeparator) ? localization.separator : separator,
      localization.units[realUnit] ?? '');
}

/// Formats a byte amount as human readable string.
///
/// The only required parameter is [amount], which is a number describing a
/// amount of bytes. That amount is then formatted with appropriate binary
/// [Unit] as determined by [Unit.bestFor]. If one prefers one can get a decimal
/// based result by providing [UnitType.decimal] as the [unitType] parameter.
///
/// ```
/// String output = format(3 * pow(1024, 3)) // 3 GiB
/// ```
///
/// Simplest way to localize the output is to provide the function with the
/// [locale] parameter. Currently supported locales are en, fi and ru.
///
/// ```
/// String output = format(3 * pow(1024, 3), locale: 'ru') // 3 ГиБ
/// ```
///
/// Output precision can be controlled with the parameters [minDecimals],
/// [maxDecimals] and [maxPrecision] which will be passed on to
/// [createPrecisionFormatter].
///
/// ```
/// String output = format(1024, minDecimals: 1) // 1,0 KiB
/// ```
///
/// To use a specific unit instead of automatically determined one, you can
/// provide the wanted unit as the [unit] parameter.
///
/// ```
/// String output = format(1024, unit: Unit.byte) // 1024 B
/// ```
///
/// ## Custom formatting
///
/// It is also possible to define the formatting manually with [formatString],
/// [separator] and [customAmountTransformer]. [formatString] can contain the
/// following placeholders _%amount_, _%sep_ and _%unit_. [separator] overrides
/// the default separator character used between the amount and the unit.
///
/// ```
/// String output = format(1024,
///   formatString: '%unit%sep%amount',
///   separator: '__') // KiB__1
/// ```
///
/// Providing a customAmountTransformer will override the default
/// [createPrecisionFormatter] number to string transformer function.
///
/// ```
/// String output = format(12.345e67,
///   customAmountTransformer: (amount) { amount.toString() },
///   unit: Unit.byte
/// ) // 1.2345e+68 B
/// ```
///
/// Custom unit can be used by providing a format string with the %unit
/// placeholder hard coded in. In addition a custom [Unit] can be provided
/// as the [unit] parameter.
///
/// ```
/// String output = format(1024,
///   formatString: '%amount half-KiB',
///   unit: Unit('half-kibibyte', 512, UnitType.binary)) // 2 half-KiB
/// ```
///
/// Will throw [ArgumentError] if any of the provided parameters is *null*,
/// customAmountTransformer is a an exception and it can be and does default
/// to null.
///
String format(num amount,
    {String locale = 'en',
    String formatString = defaultFormatString,
    String separator = defaultSeparator,
    AmountToString customAmountTransformer,
    int minDecimals = 0,
    int maxDecimals = 2,
    int maxPrecision = -1,
    Unit unit = Unit.auto,
    UnitType unitType = UnitType.binary}) {
  if (amount == null) throw ArgumentError.notNull('amount');
  if (locale == null) throw ArgumentError.notNull('locale');
  if (formatString == null) throw ArgumentError.notNull('formatString');
  if (separator == null) throw ArgumentError.notNull('separator');
  if (minDecimals == null) throw ArgumentError.notNull('minDecimals');
  if (maxDecimals == null) throw ArgumentError.notNull('maxDecimals');
  if (maxPrecision == null) throw ArgumentError.notNull('maxPrecision');
  if (unit == null) throw ArgumentError.notNull('unit');
  if (unitType == null) throw ArgumentError.notNull('unitType');

  return _formatSafeParams(
      amount,
      locale,
      formatString,
      separator,
      customAmountTransformer,
      minDecimals,
      maxDecimals,
      maxPrecision,
      unit,
      unitType);
}

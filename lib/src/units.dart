/// Binary ot Decimal based unit
///
/// Used to determine the type of [Unit] and to select appropriate unit type.
enum UnitType { binary, decimal }

/// Describes a storage amount unit
///
/// While a public constructor is provided you should really consider this as a
/// enum class instead.
///
/// ## Provided values:
///
/// * [Unit.auto]: Default, special, unit, which instructs the formatting code to
/// chose automatically choose the best unit based on the provided inputs.
/// * [Unit.byte]: While it is marked as a decimal based unit it does also refer
/// to binary based unit.
///
/// ### Decimal (1000-based multiplier) units
///  * [Unit.kilobyte]: 1 KB
///  * [Unit.megabyte]: 1 MB
///  * [Unit.gigabyte]: 1 GB
///  * [Unit.petabyte]: 1 TB
///  * [Unit.exabyte]: 1 EB
///  * [Unit.zettabyte]: 1 ZB
///  * [Unit.yottabyte]: 1 YB
///  * [Unit.kilobyte]: 1 KB
///
/// ### Binary (1024-based multiplier) units
///  * [Unit.kibibyte]: 1 KiB
///  * [Unit.mebibyte]: 1 MiB
///  * [Unit.gibibyte]: 1 GiB
///  * [Unit.tebibyte]: 1 TiB
///  * [Unit.pebibyte]: 1 PiB
///  * [Unit.exbibyte]: 1 EiB
///  * [Unit.zebibyte]: 1 ZiB
///  * [Unit.yobibyte]: 1 YiB
class Unit {
  final String name;
  final double multiplier;
  final UnitType type;

  /// Primary constructor
  ///
  /// Defines the units behaviour and identity. [name] is the name of the unit.
  /// [type] is one of the [UnitType] types, for custom units this has no
  /// functional effect. The primary parameter is [multiplier] and it is the one
  /// that is actually used by the formatting code to generate the final amount
  /// from the input. It is the number, ny which one must divide a input number,
  /// to get a appropriate amount for this particular unit. For example 1024,
  /// in the case of [Unit.kibibyte].
  const Unit(this.name, this.multiplier, this.type);

  static const auto = Unit('auto', 0, UnitType.decimal);
  static const byte = Unit('byte', 1, UnitType.decimal);

  static const kilobyte = Unit('kilobyte', 1000, UnitType.decimal);
  static const megabyte = Unit('megabyte', 1000000, UnitType.decimal);
  static const gigabyte = Unit('gigabyte', 1000000000, UnitType.decimal);
  static const terabyte = Unit('terabyte', 1000000000000, UnitType.decimal);
  static const petabyte = Unit('petabyte', 1000000000000000, UnitType.decimal);
  static const exabyte = Unit('exabyte', 1000000000000000000, UnitType.decimal);
  static const zettabyte =
      Unit('zettabyte', 1000000000000000000000, UnitType.decimal);
  static const yottabyte = Unit(
      'yottabyte',
      // Suppress analyzer error (with .0) about possible integer overflow.
      // There is no overflow in this particular case.
      1000000000000000000000000.0,
      UnitType.decimal);

  static const kibibyte = Unit('kibibyte', 1024, UnitType.binary);
  static const mebibyte = Unit('mebibyte', 1048576, UnitType.binary);
  static const gibibyte = Unit('gibibyte', 1073741824, UnitType.binary);
  static const tebibyte = Unit('tebibyte', 1099511627776, UnitType.binary);
  static const pebibyte = Unit('pebibyte', 1125899906842624, UnitType.binary);
  static const exbibyte =
      Unit('exbibyte', 1152921504606846976, UnitType.binary);
  static const zebibyte =
      Unit('zebibyte', 1180591620717411303424, UnitType.binary);
  static const yobibyte =
      Unit('yobibyte', 1208925819614629174706176, UnitType.binary);

  static const _binaryUnits = [
    Unit.yobibyte,
    Unit.zebibyte,
    Unit.exbibyte,
    Unit.pebibyte,
    Unit.tebibyte,
    Unit.gibibyte,
    Unit.mebibyte,
    Unit.kibibyte,
    Unit.byte
  ];

  static const _decimalUnits = [
    Unit.yottabyte,
    Unit.zettabyte,
    Unit.exabyte,
    Unit.petabyte,
    Unit.terabyte,
    Unit.gigabyte,
    Unit.megabyte,
    Unit.kilobyte,
    Unit.byte
  ];

  static const _byName = {
    'byte': Unit.byte,
    'kilobyte': Unit.kilobyte,
    'megabyte': Unit.megabyte,
    'gigabyte': Unit.gigabyte,
    'terabyte': Unit.terabyte,
    'petabyte': Unit.petabyte,
    'exabyte': Unit.exabyte,
    'zettabyte': Unit.zettabyte,
    'yottabyte': Unit.yottabyte,
    'kibibyte': Unit.kibibyte,
    'mebibyte': Unit.mebibyte,
    'gibibyte': Unit.gibibyte,
    'tebibyte': Unit.tebibyte,
    'pebibyte': Unit.pebibyte,
    'exbibyte': Unit.exbibyte,
    'zebibyte': Unit.zebibyte,
    'yobibyte': Unit.yobibyte
  };

  /// Find a predefined unit by its name.
  ///
  /// ```
  ///  double mbMultiplier = Unit.find('megabyte').multiplier;
  /// ```
  ///
  /// While this function is provided, you should, if possible, refer directly
  /// to the wanted unit.
  ///
  /// [name] is the name field of the requested unit.
  /// Throws [ArgumentError] if the requested unit is not found.
  static Unit find(String name) {
    var unit = _byName[name];

    if (unit == null) {
      throw ArgumentError.value(name, 'name',
          'Expected name to be one of ${_byName.keys.join(', ')}.');
    }

    return unit;
  }

  static List<Unit> _getUnitListForType(UnitType type) {
    switch (type) {
      case UnitType.binary:
        return _binaryUnits;
      case UnitType.decimal:
        return _decimalUnits;
    }
  }

  /// Determines the best unit for given amount and type.
  ///
  /// ```
  /// Unit shouldBeKibibyte = Unit.bestFor(2000, UnitType.binary);
  /// ```
  ///
  /// [amount] is the only required parameter. If [type] is not provided,
  /// will default to returning a binary based unit.
  ///
  /// Will throw [ArgumentError] if amount is a non finite value. That is
  /// [double.infinity], [double.negativeInfinity] or [double.nan].
  static Unit bestFor(double amount, [UnitType type = UnitType.binary]) {
    if (!amount.isFinite) {
      throw ArgumentError.value(amount, 'amount', 'Expected a finite value.');
    }

    var positive = amount.abs();

    if (positive == 0) {
      return Unit.byte;
    }

    return _getUnitListForType(type)
        .firstWhere((unit) => (unit.multiplier <= positive));
  }
}

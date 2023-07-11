extension StringExtension on String? {
  String? toCurrencyFormat({var format = '\$'}) {
    return format + this;
  }
}

import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String currencyFormatter(int value) {
  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
    amount: value.toDouble(),
    settings: MoneyFormatterSettings(
      symbol: 'Rp',
      thousandSeparator: '.',
      decimalSeparator: ',',
      fractionDigits: 0,
      compactFormatType: CompactFormatType.short,
      symbolAndNumberSeparator: '.',
    ),
  );
  MoneyFormatterOutput fo = fmf.output;
  return fo.symbolOnLeft.toString();
}

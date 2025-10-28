import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UtilTexto {
  static MaskTextInputFormatter cpfFormatter() {
    return MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  }

  static PhoneInputFormatter telefoneFormatter() {
    return PhoneInputFormatter(
      defaultCountryCode: 'BR',
    );
  }
}

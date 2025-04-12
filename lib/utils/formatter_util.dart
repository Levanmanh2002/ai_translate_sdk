import 'package:ai_translate/widget/input_formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:flutter/services.dart';

class FormatterUtil {
  static final List<TextInputFormatter> chatMessageFormatter = [
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(1000),
  ];
}

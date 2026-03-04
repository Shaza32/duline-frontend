// lib/localization/strings_ext.dart
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/global_state.dart';
import 'app_strings.dart';

extension StringsExt on BuildContext {
  AppStrings get strings => watch<GlobalState>().strings;
  AppStrings get stringsRead => read<GlobalState>().strings;
}

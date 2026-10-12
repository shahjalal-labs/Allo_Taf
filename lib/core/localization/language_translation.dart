import 'package:allo_taf/core/localization/english.dart';
import 'package:allo_taf/core/localization/french.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class LanguageTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
    'fr_FR': french,
  };
}

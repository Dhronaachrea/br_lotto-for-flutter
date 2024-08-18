import 'package:br_lotto/l10n/responseCode/responseCodeMsg_en.dart';
import 'package:br_lotto/l10n/responseCode/responseCodeMsg_fr.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String? loadLocalizedData(String key, String languageCode) {

  if (languageCode == "en") {
    return responseCodeMsgEng?[key];
  } else if (languageCode == "fr") {
    return responseCodeMsgFr?[key];
  }

  return null;
}
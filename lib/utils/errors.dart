import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String firebaseAuthMessages(BuildContext context, String code) {
  if (kDebugMode) {
    print("Hata Kodu: " + code);
  }
  if (code == "invalid-email") {
    return AppLocalizations.of(context).invalid_email;
  } else if (code == "expired-action-code") {
    return AppLocalizations.of(context).expired_action_code;
  } else if (code == "invalid-action-code") {
    return AppLocalizations.of(context).invalid_action_code;
  } else if (code == "user-disabled") {
    return AppLocalizations.of(context).user_disabled;
  } else if (code == "user-not-found") {
    return AppLocalizations.of(context).user_not_found;
  } else if (code == "weak-password") {
    return AppLocalizations.of(context).weak_password;
  } else if (code == "email-already-in-use") {
    return AppLocalizations.of(context).email_already_in_use;
  } else if (code == "account-exists-with-different-credential") {
    return AppLocalizations.of(context)
        .account_exists_with_different_credential;
  } else if (code == "credential-already-in-use") {
    return AppLocalizations.of(context).credential_already_in_use;
  } else if (code == "invalid-continue-uri") {
    return AppLocalizations.of(context).invalid_continue_uri;
  } else if (code == "unauthorized-continue-uri") {
    return AppLocalizations.of(context).unauthorized_continue_uri;
  } else if (code == "invalid-credential") {
    return AppLocalizations.of(context).invalid_credential;
  } else if (code == "wrong-password") {
    return AppLocalizations.of(context).wrong_password;
  } else if (code == "invalid-verification-code") {
    return AppLocalizations.of(context).invalid_verification_code;
  } else if (code == "cancelled-popup-request") {
    return AppLocalizations.of(context).cancelled_popup_request;
  } else if (code == "popup-blocked") {
    return AppLocalizations.of(context).popup_blocked;
  } else if (code == "popup-closed-by-user") {
    return AppLocalizations.of(context).popup_closed_by_user;
  } else if (code == "unauthorized-domain") {
    return AppLocalizations.of(context).unauthorized_domain;
  }
  return AppLocalizations.of(context).an_error_occurred;
}

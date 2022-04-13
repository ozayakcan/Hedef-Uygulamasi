import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConvertAgo {
  ConvertAgo(this.context);

  static ConvertAgo of(BuildContext context) {
    return ConvertAgo(context);
  }

  final BuildContext context;
  String format(DateTime dateTime) {
    int timeSub =
        DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    if (timeSub < (60 * 2)) {
      return AppLocalizations.of(context).just_now;
    } else if (timeSub >= (60 * 2) && timeSub < (60 * 60)) {
      return AppLocalizations.of(context)
          .i_minutes_ago
          .replaceAll("%i", (timeSub / 60).toString());
    } else if (timeSub >= (60 * 60) && timeSub < (60 * 60 * 2)) {
      return AppLocalizations.of(context).an_hour_ago;
    } else if (timeSub >= (60 * 60 * 2) && timeSub < (60 * 60 * 24)) {
      return AppLocalizations.of(context)
          .h_hours_ago
          .replaceAll("%h", (timeSub / (60 * 60)).toString());
    } else {
      return AppLocalizations.of(context)
          .date_time_format
          .replaceAll("%n", getDayLocalization(dateTime.weekday))
          .replaceAll("%m", dateTime.month.toString())
          .replaceAll("%d", dateTime.day.toString())
          .replaceAll("%y", dateTime.year.toString())
          .replaceAll("%h", dateTime.hour.toString())
          .replaceAll("%i", dateTime.minute.toString());
    }
  }

  String getDayLocalization(int weekday) {
    switch (weekday) {
      case 1:
        return AppLocalizations.of(context).monday;
      case 2:
        return AppLocalizations.of(context).tuesday;
      case 3:
        return AppLocalizations.of(context).wednesday;
      case 4:
        return AppLocalizations.of(context).thursday;
      case 5:
        return AppLocalizations.of(context).friday;
      case 6:
        return AppLocalizations.of(context).saturday;
      case 7:
        return AppLocalizations.of(context).sunday;
      default:
        return AppLocalizations.of(context).monday;
    }
  }
}

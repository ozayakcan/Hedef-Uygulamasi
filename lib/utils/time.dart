import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Time {
  Time(this.context);

  static Time of(BuildContext context) {
    return Time(context);
  }

  final BuildContext context;
  String elapsed(DateTime dateTime) {
    int timeSub = Time.getTimeUtc().millisecondsSinceEpoch -
        dateTime.millisecondsSinceEpoch;
    int second = 1000;
    int minute = second * 60;
    int hour = minute * 60;
    int day = hour * 24;
    if (timeSub < minute) {
      return AppLocalizations.of(context).just_now;
    } else if (timeSub >= minute && timeSub < hour) {
      return AppLocalizations.of(context)
          .minutes_ago
          .replaceAll("{minutes}", (timeSub ~/ minute).toString());
    } else if (timeSub >= hour && timeSub < hour * 2) {
      return AppLocalizations.of(context).an_hour_ago;
    } else if (timeSub >= hour * 2 && timeSub < day) {
      return AppLocalizations.of(context)
          .hours_ago
          .replaceAll("{hours}", (timeSub ~/ hour).toString());
    } else {
      return AppLocalizations.of(context)
          .date_time_format
          .replaceAll("{weekday}", getDayLocalization(dateTime.weekday))
          .replaceAll("{months}", displayTime(dateTime.month))
          .replaceAll("{days}", displayTime(dateTime.day))
          .replaceAll("{years}", displayTime(dateTime.year))
          .replaceAll("{hours}", displayTime(dateTime.hour))
          .replaceAll("{minutes}", displayTime(dateTime.minute));
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

  String displayTime(int time) {
    if (time < 10) {
      return "0" + time.toString();
    } else {
      return time.toString();
    }
  }

  static DateTime getTimeUtc() {
    return DateTime.now().toUtc();
  }

  static DateTime getLocal() {
    return DateTime.now().toLocal();
  }

  static DateTime toLocal({DateTime? time, String? timeString}) {
    if (time != null) {
      return time.toLocal();
    } else if (timeString != null) {
      return DateTime.parse(timeString).toLocal();
    } else {
      return getLocal();
    }
  }
}

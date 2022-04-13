import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/database/search_database.dart';
import '../models/search_log.dart';
import '../models/user.dart';
import '../widgets/buttons.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
import 'variables.dart';

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate(this.darkTheme, this.userid);

  bool darkTheme;
  String userid;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder(
        future: SearchDB.searchUsers(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Widget> searchList = [];
            for (final userModel in snapshot.data!) {
              searchList.add(
                profileColumn(
                  context,
                  darkTheme: darkTheme,
                  user: userModel,
                  query: query,
                  beforeClicked: () {
                    close(context, null);
                    SearchDB.addLog(userid: userid, searchStr: query);
                  },
                ),
              );
            }
            if (searchList.isNotEmpty) {
              return Column(
                children: searchList,
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: SearchDB.getLogs(userid),
      builder: (BuildContext context1,
          AsyncSnapshot<List<SearchLogModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Widget> searchs = [];
          for (final searchModel in snapshot.data!) {
            searchs.add(
              searchSuggestion(
                context,
                text: searchModel.query,
                darkTheme: darkTheme,
                onPressed: () {
                  query = searchModel.query;
                  showResults(context);
                },
                onLongPressed: () {
                  defaultAlertbox(
                    context,
                    title: AppLocalizations.of(context).remove_query,
                    descriptions: [
                      Text(
                        AppLocalizations.of(context).remove_query_desc,
                        style: simpleTextStyle(
                            Variables.fontSizeNormal, darkTheme),
                      ),
                    ],
                    darkTheme: darkTheme,
                    actionYes: () {
                      SearchDB.removeLog(userid: userid, key: searchModel.key)
                          .then((value) {});
                      ScaffoldSnackbar.of(context).show(
                          AppLocalizations.of(context).remove_query_success);
                    },
                    actionNo: () {},
                  );
                },
              ),
            );
          }
          if (searchs.isNotEmpty) {
            return Column(
              children: searchs,
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
}

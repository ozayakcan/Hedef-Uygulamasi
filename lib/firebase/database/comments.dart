import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/comment.dart';
import '../../models/user.dart';
import '../../utils/time.dart';
import 'database.dart';
import 'user_database.dart';

class CommentsDB {
  static DatabaseReference getCommentsRef(String postKey) {
    return Database.getReference(Database.commentsString).child(postKey);
  }

  static Future addComment(
    String postKey,
    String userid,
    String comment,
  ) async {
    try {
      DatabaseReference databaseReference = getCommentsRef(postKey).push();
      String key = databaseReference.key!;
      databaseReference.set(
        CommentModel(
          UserModel.empty(),
          key,
          userid,
          comment,
          Time.getTimeUtc(),
        ).toJson(),
      );
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Yorum eklenemedi. Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future<List<CommentModel>> getCommentsList(
    DatabaseEvent databaseEvent,
  ) async {
    List<CommentModel> commentList = [];
    for (final commentChild in databaseEvent.snapshot.children) {
      final jsonComment = commentChild.value as Map<dynamic, dynamic>;
      CommentModel commentModel = CommentModel.fromJson(jsonComment);
      DatabaseEvent userEvent =
          await UserDB.getUserRef(commentModel.userid).once();
      if (userEvent.snapshot.exists) {
        final jsonUser = userEvent.snapshot.value as Map<dynamic, dynamic>;
        UserModel userModel = UserModel.fromJson(jsonUser);
        commentModel.userModel = userModel;
      }
      commentList.add(commentModel);
    }
    commentList.sort((a, b) => a.date.compareTo(b.date));
    return commentList;
  }
}

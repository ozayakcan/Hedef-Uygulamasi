import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/key.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../widgets/widgets.dart';
import 'database.dart';
import 'followers_database.dart';
import 'user_database.dart';

class PostsDB {
  static Query getPostsQuery(String userid) {
    return Database.getReference(Database.postsString)
        .orderByChild(Database.useridString)
        .equalTo(userid);
  }

  static DatabaseReference getCommentsRef(String postKey) {
    return Database.getReference(Database.commentsString).child(postKey);
  }

  static Future<List<PostModel>> getFollowingPost(String userid) async {
    List<PostModel> posts = [];
    try {
      DatabaseEvent followingEvent =
          await FollowersDB.getFollowingRef(userid).once();
      for (final folllowingChild in followingEvent.snapshot.children) {
        final jsonFollowing = folllowingChild.value as Map<dynamic, dynamic>;
        KeyModel keyModel = KeyModel.fromJson(jsonFollowing);
        posts.addAll(await getPosts(keyModel.key));
      }
      return posts;
    } catch (e) {
      if (kDebugMode) {
        print("Takip edilenlerin gönderileri getirilemedi! Hata: " +
            e.toString());
      }
      return posts;
    }
  }

  static Future<List<PostModel>> getPosts(String userid) async {
    List<PostModel> posts = [];
    try {
      DatabaseEvent userEvent = await UserDB.getUserRef(userid).once();
      if (userEvent.snapshot.exists) {
        final jsonUser = userEvent.snapshot.value as Map<dynamic, dynamic>;
        UserModel userModel = UserModel.fromJson(jsonUser);
        DatabaseEvent postsEvent = await getPostsQuery(userid).once();
        for (final postsChild in postsEvent.snapshot.children) {
          final jsonPost = postsChild.value as Map<dynamic, dynamic>;
          PostModel post = PostModel.fromJson(jsonPost);
          post.userModel = userModel;
          posts.add(post);
        }
      }
      return posts;
    } catch (e) {
      if (kDebugMode) {
        print("Gönderiler getirilemedi! Hata: " + e.toString());
      }
      return posts;
    }
  }

  static List<PostModel> getPostFromDBEvent(
      DatabaseEvent postsEvent, UserModel userModel) {
    List<PostModel> posts = [];

    return posts;
  }

  static Future<List<Widget>> getPostsAsWidgets(
    BuildContext context, {
    required List<PostModel> posts,
    required bool darkTheme,
    bool inProfile = false,
    bool includeFollowing = true,
  }) async {
    List<PostModel> sortedPosts = PostModel.sort(posts);
    List<Widget> tempPostsWidget = [];
    for (final postModel in sortedPosts) {
      tempPostsWidget.add(PostWidget(
        postModel: postModel,
        darkTheme: darkTheme,
        inProfile: inProfile,
      ));
    }
    return tempPostsWidget;
  }
}

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

  static DatabaseReference getFavoritesRef(String postKey) {
    return Database.getReference(Database.favoritesString).child(postKey);
  }

  static DatabaseReference favoritedRef(String postKey, String userid) {
    return Database.getReference(Database.favoritesString)
        .child(postKey)
        .child(userid);
  }

  static Future addFavorite(String postKey, String userid) async {
    try {
      DatabaseReference databaseReference = favoritedRef(postKey, userid);
      DatabaseEvent databaseEvent = await databaseReference.once();
      await favoritedRef(postKey, userid).set(
          databaseEvent.snapshot.exists ? null : KeyModel(userid).toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Favori eklenemedi. Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static DatabaseReference getCommentsRef(String postKey) {
    return Database.getReference(Database.commentsString).child(postKey);
  }

  static Future<List<Post>> getFollowingPost(String userid) async {
    List<Post> posts = [];
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

  static Future<List<Post>> getPosts(String userid) async {
    List<Post> posts = [];
    try {
      DatabaseEvent userEvent = await UserDB.getUserRef(userid).once();
      if (userEvent.snapshot.exists) {
        final jsonUser = userEvent.snapshot.value as Map<dynamic, dynamic>;
        UserModel userModel = UserModel.fromJson(jsonUser);
        DatabaseEvent postsEvent = await getPostsQuery(userid).once();
        posts.addAll(getPostFromDBEvent(postsEvent, userModel));
      }
      return posts;
    } catch (e) {
      if (kDebugMode) {
        print("Gönderiler getirilemedi! Hata: " + e.toString());
      }
      return posts;
    }
  }

  static List<Post> getPostFromDBEvent(
      DatabaseEvent postsEvent, UserModel userModel) {
    List<Post> posts = [];
    for (final postsChild in postsEvent.snapshot.children) {
      final jsonPost = postsChild.value as Map<dynamic, dynamic>;
      Post post = Post.fromJson(jsonPost);
      post.userModel = userModel;
      posts.add(post);
    }
    return posts;
  }

  static Future<List<Widget>> getPostsAsWidgets(
    BuildContext context, {
    required String userid,
    required bool darkTheme,
    bool inProfile = false,
    bool includeFollowing = true,
  }) async {
    List<Post> postsOrj = [];
    postsOrj.addAll(await PostsDB.getPosts(userid));
    if (includeFollowing) {
      postsOrj.addAll(await PostsDB.getFollowingPost(userid));
    }
    List<Post> sortedPosts = Post.sort(postsOrj);
    List<Widget> tempPostsWidget = [];
    for (final postData in sortedPosts) {
      tempPostsWidget.add(PostWidget(
        userModel: postData.userModel,
        postKey: postData.key,
        content: postData.content,
        dateTime: postData.date,
        darkTheme: darkTheme,
        inProfile: inProfile,
      ));
    }
    return tempPostsWidget;
  }
}

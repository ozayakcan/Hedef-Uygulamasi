import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/key.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../utils/time.dart';
import '../../views/post.dart';
import 'database.dart';
import 'favorites_database.dart';
import 'followers_database.dart';
import 'user_database.dart';

class PostsDB {
  static Query getPostsQuery(String userid) {
    return Database.getReference(Database.postsString)
        .orderByChild(Database.useridString)
        .equalTo(userid);
  }

  static DatabaseReference getPostByKeyRef(String postKey) {
    return Database.getReference(Database.postsString).child(postKey);
  }

  static DatabaseReference getCommentsRef(String postKey) {
    return Database.getReference(Database.commentsString).child(postKey);
  }

  static Future addPost(
      {required String userid, required String content}) async {
    try {
      DatabaseReference databaseReference = getPostsQuery(userid).ref.push();
      String key = databaseReference.key!;
      PostModel postModel =
          PostModel(UserModel.empty(), userid, key, content, Time.getTimeUtc());
      await databaseReference.set(postModel.toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Gönderi oluşturulamadı! Hata: " + e.toString());
      }
      return e.toString();
    }
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
      DatabaseEvent postsEvent = await getPostsQuery(userid).once();
      for (final postsChild in postsEvent.snapshot.children) {
        final jsonPost = postsChild.value as Map<dynamic, dynamic>;
        PostModel? postModel = await getPostModel(jsonPost);
        if (postModel != null) {
          posts.add(postModel);
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

  static Future<PostModel?> getPostModel(Map<dynamic, dynamic> jsonPost) async {
    try {
      PostModel post = PostModel.fromJson(jsonPost);
      DatabaseEvent userEvent = await UserDB.getUserRef(post.userid).once();
      if (userEvent.snapshot.exists) {
        final jsonUser = userEvent.snapshot.value as Map<dynamic, dynamic>;
        UserModel userModel = UserModel.fromJson(jsonUser);
        post.userModel = userModel;
        return post;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("PostModel getirilemedi! Hata: " + e.toString());
      }
      return null;
    }
  }

  static Future<List<PostModel>> getFavoritedPosts(String userid) async {
    List<PostModel> posts = [];
    try {
      List<String> favoritedList = await FavoritesDB.getUserFavorites(userid);
      for (final favorited in favoritedList) {
        DatabaseEvent databaseEvent = await getPostByKeyRef(favorited).once();
        final jsonPost = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
        PostModel? postModel = await getPostModel(jsonPost);
        if (postModel != null) {
          posts.add(postModel);
        }
      }
      return posts;
    } catch (e) {
      if (kDebugMode) {
        print("Favori gönderiler getirilemedi! Hata: " + e.toString());
      }
      return posts;
    }
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

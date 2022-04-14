import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/key.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'database.dart';
import 'followers_database.dart';
import 'user_database.dart';

class PostsDB {
  static DatabaseReference getPostsRef(String userid) {
    return Database.getReference(Database.postsString).child(userid);
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
        DatabaseEvent postsEvent = await getPostsRef(userid).once();
        for (final postsChild in postsEvent.snapshot.children) {
          final jsonPost = postsChild.value as Map<dynamic, dynamic>;
          Post post = Post.fromJson(jsonPost);
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
}

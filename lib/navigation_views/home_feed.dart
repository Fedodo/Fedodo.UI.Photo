import 'package:activitypub/Models/activity.dart';
import 'package:activitypub/Models/post.dart' as activity_pub;
import 'package:fedodo_ui_photo/posts/post.dart';
import 'package:flutter/material.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Post(
          activity: Activity<activity_pub.Post>(
            null,
            activity_pub.Post(
              [
                "to",
              ],
              null,
              null,
              null,
              null,
              "content",
              "id",
              "Post",
              DateTime.now(),
              "https://mastodon.social/@Fedodo",
              null,
              null,
            ),
            "id",
            "Activity",
            null,
            "actor",
            null,
            null,
            null,
            null,
            null,
          ),
          isClickable: true,
        ),
      ],
    );
  }
}

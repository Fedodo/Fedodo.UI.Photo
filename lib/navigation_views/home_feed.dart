import 'package:activitypub/Models/post.dart' as activity_pub;
import 'package:activitypub/activitypub.dart';
import 'package:fedodo_ui_photo/posts/post.dart';
import 'package:flutter/material.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoPost(
            activity: Activity<Post>(
                ["https://www.w3.org/ns/activitystreams#Public"],
                activity_pub.Post(
                  [
                    "https://www.w3.org/ns/activitystreams#Public",
                  ],
                  null,
                  null,
                  null,
                  null,
                  "Hello World!",
                  "https://ard.social/users/tagesschau/statuses/110823757724908531",
                  "Note",
                  DateTime.now(),
                  "https://mastodon.social/@Fedodo",
                  null,
                  [
                    Document("Document", null, null, null, Uri.tryParse("https://pixelfed.de/storage/m/_v2/482439783472092612/c51ea9690-856390/0D4b6tybOa94/7DAAIIkQDKuHdPtJW8Y5nIAco6Lacy2AouOCTwwe.jpg"))
                  ],
                ),
                "https://ard.social/users/tagesschau/statuses/110823757724908531/activity",
                "Create",
                DateTime.now(),
                "https://ard.social/users/tagesschau",
                null,
                null,
                null,
                null,
                null),
            isClickable: true,
          ),
        ],
      ),
    );
  }
}

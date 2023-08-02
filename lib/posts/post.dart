import 'package:activitypub/Models/CoreTypes/object.dart';
import 'package:activitypub/activitypub.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_general/widgets/posts/components/post_bottom.dart';
import 'package:fedodo_general/widgets/posts/components/user_header.dart';
import 'package:fedodo_ui_photo/navigation_views/profile/profile.dart';
import 'package:fedodo_ui_photo/posts/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:url_launcher/url_launcher.dart';

class PhotoPost extends StatelessWidget {
  const PhotoPost({
    super.key,
    required this.isClickable,
    required this.activity,
  });

  final bool isClickable;
  final Activity<Post> activity;

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(activity.object.content);

    List<Widget> children = [
      UserHeader(
        profileId: activity.object.attributedTo!,
        publishedDateTime: activity.published,
        profile: Profile(
          profileId: activity.object.attributedTo!,
        ),
      ),
      CachedNetworkImage(
        imageUrl: (activity.object.attachment?.first as dynamic).url,
      ),
      // Html(
      //   data: document.outerHtml,
      //   style: {
      //     "p": Style(
      //       fontSize: FontSize(16),
      //     ),
      //     "a": Style(
      //       fontSize: FontSize(16),
      //       textDecoration: TextDecoration.none,
      //     ),
      //   },
      //   extensions: [
      //     TagExtension(
      //       tagsToExtend: {"a"},
      //       builder: (extensionContext) {
      //         return InkWell(
      //           onTap: () => {
      //             launchUrl(
      //               Uri.parse(
      //                 extensionContext.element!.attributes["href"]!,
      //               ),
      //             ),
      //           },
      //           child: Text(
      //             extensionContext.node.text!,
      //             style: const TextStyle(
      //               color: Colors.blue,
      //               fontSize: 16,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      PostBottom(
        activity: activity,
        createPostView: const CreatePost(),
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
    ];

    return InkWell(
      onTap: () => {openPost(context)},
      child: Ink(
        child: Column(
          children: children,
        ),
      ),
    );
  }

  void openPost(BuildContext context) {
    if (isClickable) {
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     transitionDuration: const Duration(milliseconds: 300),
      //     reverseTransitionDuration: const Duration(milliseconds: 300),
      //     pageBuilder: (context, animation, animation2) => FullPostView(
      //       activity: activity,
      //     ),
      //     transitionsBuilder: (context, animation, animation2, widget) =>
      //         SlideTransition(
      //             position: Tween(
      //               begin: const Offset(1.0, 0.0),
      //               end: const Offset(0.0, 0.0),
      //             ).animate(animation),
      //             child: widget),
      //   ),
      // );
    }
  }
}

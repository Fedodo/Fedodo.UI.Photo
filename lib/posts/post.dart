import 'package:activitypub/activitypub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:html/dom.dart" as dom;  
import 'package:html/parser.dart' as htmlparser;
import 'package:url_launcher/url_launcher.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.isClickable, 
    required this.activity,
  });

  final bool isClickable;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(activity.object.content);
    
    List<Widget> children = [
      UserHeader(
        profileId: activity.object.attributedTo,
        publishedDateTime: activity.published,
      ),
      Html(
        data: document.outerHtml,
        style: {
          "p": Style(
            fontSize: FontSize(16),
          ),
          "a": Style(
            fontSize: FontSize(16),
            textDecoration: TextDecoration.none,
          ),
        },
        extensions: [
          TagExtension(
            tagsToExtend: {"a"},
            builder: (extensionContext) {
              return InkWell(
                onTap: () => {
                  launchUrl(
                    Uri.parse(
                      extensionContext.element!.attributes["href"]!,
                    ),
                  ),
                },
                child: Text(
                  extensionContext.node.text!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ],
      )
      PostBottom(
        activity: activity,
        appTitle: appTitle,
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
      //       appTitle: appTitle,
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

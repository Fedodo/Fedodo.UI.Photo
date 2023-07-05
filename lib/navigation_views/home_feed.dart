import 'package:fedodo_ui_photo/posts/post.dart';
import 'package:flutter/material.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Post(),
        Post(),
      ],
    );
  }
}

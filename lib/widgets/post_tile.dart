import 'package:flutter/material.dart';
import 'package:social_connect/widgets/custom_image.dart';
import 'package:social_connect/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}

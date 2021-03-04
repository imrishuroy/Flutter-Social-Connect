import 'package:flutter/material.dart';
import 'package:social_connect/widgets/header.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  const Comments({Key key, this.postId, this.postOwnerId, this.postMediaUrl})
      : super(key: key);
  @override
  CommentsState createState() => CommentsState(
      postId: this.postId,
      postOwnerId: this.postOwnerId,
      postMediaUrl: this.postMediaUrl);
}

class CommentsState extends State<Comments> {
  final commentsController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({Key key, this.postId, this.postOwnerId, this.postMediaUrl});

  buildComments() {
    return Text('Comments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context: context, title: 'Comments'),
      body: Column(
        children: [
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentsController,
              decoration: InputDecoration(
                labelText: 'Write a comment',
              ),
            ),
            trailing: OutlinedButton(
              onPressed: () {},
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Comment');
  }
}

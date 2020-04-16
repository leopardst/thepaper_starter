import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';

class CommentsListTile extends StatelessWidget {
  const CommentsListTile({Key key, @required this.comment }) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.name),
      subtitle: Text(comment.content),
    );
  }
}

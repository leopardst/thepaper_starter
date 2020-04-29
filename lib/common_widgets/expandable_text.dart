import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool showFullText = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        crossFadeState: widget.showFullText ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Text(
            widget.text,
        ),
        secondChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.text,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () => {setState(() => widget.showFullText = !widget.showFullText)},
              child: Text(
                'See More',
                style: TextStyle(color: Colors.grey[600]),
              )
            ),
          ]),
        );
  }
}



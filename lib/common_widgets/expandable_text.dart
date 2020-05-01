import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {

  bool showFullText = false;
  static const defaultLines = 5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: widget.text);
      final tp = TextPainter(text: span,textDirection:TextDirection.ltr , maxLines: defaultLines);
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState: showFullText ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                onTap: () => {setState(() => showFullText = !showFullText)},
                child: Text(
                  'See More',
                  style: TextStyle(color: Colors.grey[600]),
                )
              ),
            ]),
        );
      }
      else{
       return Text(widget.text);
      }
    });
  }
}



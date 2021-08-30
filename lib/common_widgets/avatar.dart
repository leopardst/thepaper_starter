import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    required this.photoUrl,
    required this.radius,
    this.borderColor,
    this.borderWidth,
    this.character,
  });
  final String? photoUrl;
  final double radius;
  final Color? borderColor;
  final double? borderWidth;
  final String? character;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _borderDecoration(),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blueAccent[100],
        backgroundImage: photoUrl != null ? CachedNetworkImageProvider(photoUrl!) : null,
        child: photoUrl == null ? Text(character!, style: TextStyle(color: Colors.white)) : null,
      ),
    );
  }

  Decoration? _borderDecoration() {
    if (borderColor != null && borderWidth != null) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor!,
          width: borderWidth!,
        ),
      );
    }
    return null;
  }
}

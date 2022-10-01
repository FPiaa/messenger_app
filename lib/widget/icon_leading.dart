import 'package:flutter/material.dart';

import '../models/conversa.dart';

class IconLeading extends StatelessWidget {
  const IconLeading({
    Key? key,
    required this.conversa,
    this.radius,
    required this.onTap,
  }) : super(key: key);

  final Conversa conversa;
  final double? radius;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var valor = radius ?? 20;
    double imageSize = valor * 2;
    return GestureDetector(
      onTap: () => onTap(),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        // foregroundImage: NetworkImage('https://via.placeholder.com/150'),
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: conversa.imageUrl != null
                ? Image.asset(conversa.imageUrl!)
                : Icon(
                    Icons.person,
                    size: imageSize,
                    color: Colors.grey,
                  ),
          ),
        ),
      ),
    );
  }
}

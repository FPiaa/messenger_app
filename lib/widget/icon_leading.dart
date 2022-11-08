import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class IconLeading extends StatelessWidget {
  const IconLeading({
    Key? key,
    required this.pessoa,
    this.radius,
    required this.onTap,
  }) : super(key: key);

  final Pessoa pessoa;
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
            child: pessoa.photo != null && pessoa.photo!.isNotEmpty
                ? Image.asset(pessoa.photo!)
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

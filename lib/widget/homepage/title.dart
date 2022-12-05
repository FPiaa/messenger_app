import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class ConversaTitle extends StatelessWidget {
  final Pessoa? destinatario;
  const ConversaTitle({
    Key? key,
    this.destinatario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (destinatario == null) {
      return const SizedBox.shrink();
    }
    return Text(
      destinatario!.username,
      style: const TextStyle(fontSize: 20, overflow: TextOverflow.clip),
      overflow: TextOverflow.ellipsis,
    );
  }
}

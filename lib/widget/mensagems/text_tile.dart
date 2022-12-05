import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';

class TextTile extends StatelessWidget {
  final Mensagem mensagem;
  const TextTile({
    super.key,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SelectableText(
          mensagem.content!,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Text(
            DateFormat.jm().format(
                DateTime.fromMillisecondsSinceEpoch(mensagem.dataEnvio)),
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

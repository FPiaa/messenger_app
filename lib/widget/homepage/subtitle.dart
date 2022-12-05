import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';

class ConversaSubTitle extends StatelessWidget {
  const ConversaSubTitle({
    Key? key,
    required this.conversa,
  }) : super(key: key);

  final Conversa? conversa;

  @override
  Widget build(BuildContext context) {
    if (conversa == null || conversa?.conteudoUltimaMensagem == null) {
      return Container();
    } else {
      return Text(
        conversa!.conteudoUltimaMensagem!,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}

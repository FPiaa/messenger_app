import 'package:flutter/material.dart';

import '../../models/conversa.dart';
import 'mensagem_tile.dart';

class ListViewMensagem extends StatelessWidget {
  const ListViewMensagem({
    Key? key,
    required this.conversa,
  }) : super(key: key);

  final Conversa conversa;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        // TODO: Fazer a mensagem mostrar a hora de envio em formato XX:XX
        // e mostrar o nome de quem enviou em caso de grupo
        return ListTileMensagem(mensagem: conversa.mensagens[index]);
      },
      itemCount: conversa.mensagens.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      shrinkWrap: true,
      // reverse: true,
    );
  }
}

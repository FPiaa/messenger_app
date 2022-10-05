import 'package:flutter/material.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:provider/provider.dart';

import '../../models/conversa.dart';
import 'mensagem_tile.dart';

class ListViewMensagem extends StatefulWidget {
  const ListViewMensagem({
    Key? key,
    required this.conversa,
  }) : super(key: key);

  final Conversa conversa;

  @override
  State<ListViewMensagem> createState() => _ListViewMensagemState();
}

class _ListViewMensagemState extends State<ListViewMensagem> {
  late MensagensSelecionadas mensagensSelecionadas;

  @override
  Widget build(BuildContext context) {
    mensagensSelecionadas = Provider.of<MensagensSelecionadas>(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        // TODO: Fazer a mensagem mostrar a hora de envio em formato XX:XX
        // e mostrar o nome de quem enviou em caso de grupo
        return ListTileMensagem(
          mensagem: widget.conversa.mensagens[index],
          selecionada: mensagensSelecionadas.mensagem
              .contains(widget.conversa.mensagens[index]),
        );
      },
      itemCount: widget.conversa.mensagens.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      shrinkWrap: true,
      // reverse: true,
    );
  }
}

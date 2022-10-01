import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';
import 'package:messenger_app/widget/icon_leading.dart';
import 'package:messenger_app/widget/mensagem_list/mensagem_list.dart';
import 'package:messenger_app/widget/mensagem_list/mensagem_tile.dart';

import '../models/conversa.dart';
import '../widget/input_message.dart';

class ConversaPage extends StatefulWidget {
  final Conversa conversa;

  const ConversaPage({super.key, required this.conversa});

  @override
  State<ConversaPage> createState() => _ConversaPageState();
}

//TODO: Assumindo que o usuário é a pessoa[0] do repositório
// criar um estado que permita qual é o usuário para formatar
// corretamente.
class _ConversaPageState extends State<ConversaPage> {
  final formKey = GlobalKey<FormState>();
  final conteudo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                const SizedBox(width: 8),
                IconLeading(
                  conversa: widget.conversa,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 88,
        title: Text(widget.conversa.nome),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () => {
                      setState(() {
                        widget.conversa.mensagens.add(Mensagem(
                            remetente: widget.conversa.participantes[0],
                            content: "Mensagem extra"));
                      })
                    },
                icon: const Icon(Icons.plus_one)),
          )
        ],
      ),
      body: Stack(children: [
        ListViewMensagem(
          conversa: widget.conversa,
        ),
        Input(formKey: formKey, conteudo: conteudo)
      ]),
    );
  }
}

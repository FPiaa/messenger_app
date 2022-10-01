import 'package:flutter/material.dart';
import 'package:messenger_app/models/mensagem.dart';

import '../models/conversa.dart';

class ConversaPage extends StatefulWidget {
  final Conversa conversa;

  const ConversaPage({super.key, required this.conversa});

  @override
  State<ConversaPage> createState() => _ConversaPageState();
}

class _ConversaPageState extends State<ConversaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversa.nome),
      ),
      body: Stack(children: [
        ListView.separated(
            itemBuilder: (context, index) {
              // TODO: Fazer a mensagem mostrar a hora de envio em formato XX:XX
              // e mostrar o nome de quem enviou em caso de grupo
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.conversa.mensagens[index].content),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: widget.conversa.mensagens.length)
      ]),
    );
  }
}

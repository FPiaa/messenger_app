import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';
import 'package:messenger_app/widget/icon_leading.dart';

import '../models/conversa.dart';

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
        ListView.builder(
          itemBuilder: (context, index) {
            // TODO: Fazer a mensagem mostrar a hora de envio em formato XX:XX
            // e mostrar o nome de quem enviou em caso de grupo
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: widget.conversa.mensagens[index].remetente ==
                        PessoaRepository.pessoas[0]
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (widget.conversa.mensagens[index].remetente ==
                            PessoaRepository.pessoas[0]
                        ? Colors.blue[200]
                        : Colors.grey[200]),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SelectableText(
                        widget.conversa.mensagens[index].content,
                      ),
                      // TODO: alinahr o horário a direita sem mudar o tamanho da widget
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Text(
                          DateFormat.jm().format(
                              widget.conversa.mensagens[index].dataEnvio),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: widget.conversa.mensagens.length,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shrinkWrap: true,
          // reverse: true,
        ),
        Input(formKey: formKey, conteudo: conteudo)
      ]),
    );
  }
}

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.formKey,
    required this.conteudo,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController conteudo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => print("Abrir imagens"),
              ),
            ),
            Form(
              key: formKey,
              child: Flexible(
                child: TextField(
                  controller: conteudo,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) => print(conteudo.text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    hintText: "Mensagem",
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => print("enviar mensagem"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:messenger_app/controllers/conversa_controller.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:messenger_app/repository/conversas_repository.dart';
import 'package:messenger_app/widget/icon_leading.dart';
import 'package:messenger_app/widget/mensagem_list/mensagem_list.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';
import '../widget/input_message.dart';

class ConversaPage extends StatefulWidget {
  final Conversa conversa;

  const ConversaPage({super.key, required this.conversa});

  @override
  State<ConversaPage> createState() => _ConversaPageState();
}

class _ConversaPageState extends State<ConversaPage> {
  final formKey = GlobalKey<FormState>();
  final conteudo = TextEditingController();
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late MensagensSelecionadas mensagensSelecionadas;

  @override
  Widget build(BuildContext context) {
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    mensagensSelecionadas = Provider.of<MensagensSelecionadas>(context);
    ConversaController conversaController =
        ConversaController(conversaRepository: ConversaRepository());
    return Scaffold(
      appBar: mensagensSelecionadas.mensagem.isEmpty
          ? AppBar(
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      const SizedBox(width: 8),
                      IconLeading(
                        pessoa: widget.conversa.participantes.firstWhere(
                            (element) =>
                                element != usuarioAtivoProvider.pessoa),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              leadingWidth: 88,
              title: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.amber[100],
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Profile(
                                pessoa: widget.conversa.participantes
                                    .firstWhere((element) =>
                                        element != usuarioAtivoProvider.pessoa),
                                isCurrentUser: false)));
                      },
                      child: Text(widget.conversa.participantes
                          .firstWhere((element) =>
                              element != usuarioAtivoProvider.pessoa)
                          .username),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () => {
                            setState(() {
                              widget.conversa.mensagens.add(Mensagem(
                                  remetente: usuarioAtivoProvider.pessoa,
                                  content: "Mensagem extra"));
                            })
                          },
                      icon: const Icon(Icons.plus_one)),
                )
              ],
            )
          : AppBar(
              leading: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                splashColor: Colors.amber[100],
                splashFactory: InkRipple.splashFactory,
                onTap: () {
                  mensagensSelecionadas.clear();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              title: mensagensSelecionadas.mensagem.length == 1
                  ? const Text("1 mensagem selecionada")
                  : Text(
                      "${mensagensSelecionadas.mensagem.length} mensagem selecionadas"),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: mensagensSelecionadas.mensagem.any((element) =>
                          element.remetente != usuarioAtivoProvider.pessoa)
                      ? null
                      : () {
                          for (var mensagem in mensagensSelecionadas.mensagem) {
                            conversaController.deleteMessage(
                                widget.conversa, mensagem);
                          }
                          mensagensSelecionadas.clear();
                        },
                )
              ],
            ),
      body: Stack(children: [
        SingleChildScrollView(
          child: ListViewMensagem(
            conversa: widget.conversa,
          ),
        ),
        Input(
          formKey: formKey,
          conteudo: conteudo,
          conversa: widget.conversa,
          pessoa: usuarioAtivoProvider.pessoa,
          callback: () {
            setState(() {});
          },
        )
      ]),
    );
  }
}

import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/icon_leading.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class ConversaPage extends StatefulWidget {
  final Conversa conversa;
  final Pessoa destinatario;

  const ConversaPage(
      {super.key, required this.conversa, required this.destinatario});

  @override
  State<ConversaPage> createState() => _ConversaPageState();
}

class _ConversaPageState extends State<ConversaPage> {
  final formKey = GlobalKey<FormState>();
  final conteudo = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late MensagensSelecionadas mensagensSelecionadas;
  late ConversaProvider conversaProvider;
  List<Mensagem> mensagens = [];
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    conversaProvider = context.read<ConversaProvider>();
    usuarioAtivoProvider = context.read<UsuarioAtivoProvider>();
    conversaProvider.firebaseDatabase
        .ref("${DatabaseConstants.pathMessageCollection}/${widget.conversa.id}")
        .onValue
        .listen((event) async {
      mensagens = await conversaProvider.getMessages(
          conversaId: widget.conversa.id, limit: 50);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    mensagensSelecionadas = Provider.of<MensagensSelecionadas>(context);
    conversaProvider = Provider.of<ConversaProvider>(context);
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
                        pessoa: widget.destinatario,
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
                        clearState();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Profile(pessoa: usuarioAtivoProvider.pessoa),
                        ));
                      },
                      child: Text(widget.destinatario.username),
                    ),
                  ),
                ],
              ),
            )
          : AppBar(
              leading: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                splashColor: Colors.amber[100],
                splashFactory: InkRipple.splashFactory,
                onTap: () {
                  clearState();
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
                  icon: const Icon(Icons.delete),
                  onPressed: mensagensSelecionadas.mensagem.any((element) =>
                          element.remetente != usuarioAtivoProvider.pessoa.id)
                      ? null
                      : () {
                          for (var mensagem in mensagensSelecionadas.mensagem) {
                            conversaProvider.deleteMessage(
                                conversaId: widget.conversa.id,
                                mensagem: mensagem);
                          }
                          mensagensSelecionadas.clear();
                        },
                ),
                IconButton(
                    onPressed: () => mensagensSelecionadas.clear(),
                    icon: const Icon(Icons.cancel))
              ],
            ),
      body: SafeArea(
        child: Column(children: [buildMessageList(), buildInput()]),
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
        stream: conversaProvider.firebaseDatabase
            .ref(
                "${DatabaseConstants.pathMessageCollection}/${widget.conversa.id}")
            .onValue,
        builder: ((context, event) {
          if (event.hasData) {
            var data =
                event.data!.snapshot.children.map((e) => e.value).toList();
            var mensagens = data
                .map((e) => Mensagem.fromJson((e as Map<dynamic, dynamic>)))
                .skip(max(0, data.length - 50))
                .toList()
                .reversed
                .toList();
            return Flexible(
              fit: FlexFit.tight,
              child: ListView.builder(
                controller: scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  // TODO: Fazer a mensagem mostrar a hora de envio em formato XX:XX
                  // e mostrar o nome de quem enviou em caso de grupo
                  return buildMessageTile(
                    mensagem: mensagens[index],
                    selecionada: mensagensSelecionadas.mensagem
                        .contains(mensagens[index]),
                  );
                },
                itemCount: mensagens.length,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shrinkWrap: true,
                // reverse: true,
              ),
            );
          } else {
            return Flexible(fit: FlexFit.tight, child: Container());
          }
        }));
  }

  Widget buildMessageTile({
    required Mensagem mensagem,
    required bool selecionada,
  }) {
    return GestureDetector(
      onTap: mensagensSelecionadas.mensagem.isEmpty
          ? null
          : () => mensagensSelecionadas.mensagem.contains(mensagem)
              ? mensagensSelecionadas.remove(mensagem)
              : mensagensSelecionadas.save(mensagem),
      onLongPress: () => mensagensSelecionadas.mensagem.contains(mensagem)
          ? mensagensSelecionadas.remove(mensagem)
          : mensagensSelecionadas.save(mensagem),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: (mensagem.remetente == usuarioAtivoProvider.pessoa.id
            ? (selecionada ? Colors.green[50] : Colors.white)
            : (selecionada ? Colors.green[50] : Colors.white)),
        child: Align(
          alignment: mensagem.remetente == usuarioAtivoProvider.pessoa.id
              ? Alignment.topRight
              : Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (mensagem.remetente == usuarioAtivoProvider.pessoa.id
                  ? (selecionada ? Colors.blue[50] : Colors.blue[200])
                  : (selecionada ? Colors.blue[50] : Colors.grey[100])),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SelectableText(
                  mensagem.content,
                ),
                // TODO: alinahr o horário a direita sem mudar o tamanho da widget
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                        mensagem.dataEnvio)),
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSendMessage() async {
    conversaProvider.sendMessage(
      conversaId: widget.conversa.id,
      mensagem: Mensagem(
          remetente: usuarioAtivoProvider.pessoa.id,
          content: conteudo.text.trim(),
          dataEnvio: DateTime.now().millisecondsSinceEpoch),
    );
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    conteudo.clear();
    setState(() {});
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ainda não tem acesso a câmera e arquivos"),
                  ),
                ),
              ),
            ),
            Form(
              child: Flexible(
                child: TextFormField(
                  controller: conteudo,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  onChanged: (_) {
                    var text = conteudo.text.trim();
                    if (text.length == 1 || text.isEmpty) setState(() {});
                  },
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
                onPressed:
                    conteudo.text.trim().isNotEmpty ? onSendMessage : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    int limit = 20;
    int limitIncrement = 20;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        limit += limitIncrement;
      });
    }
  }

  clearState() {
    setState(() {
      mensagensSelecionadas.clear();
      conteudo.clear();
    });
  }
}

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/conversa_page.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/homepage/subtitle.dart';
import 'package:messenger_app/widget/homepage/title.dart';
import 'package:messenger_app/widget/homepage/trailing.dart';
import 'package:messenger_app/widget/icon_leading.dart';
import 'package:provider/provider.dart';

class ConversaItem extends StatefulWidget {
  final Conversa? conversa;
  final String destinatarioId;
  final Map<String, Pessoa> pessoas;
  const ConversaItem(
      {super.key,
      this.conversa,
      required this.pessoas,
      required this.destinatarioId});

  @override
  State<ConversaItem> createState() => _ConversaItemState();
}

class _ConversaItemState extends State<ConversaItem> {
  late StreamSubscription<DatabaseEvent> listenForUserChanges;
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late ProfileProvider profileProvider;
  late Pessoa? destinatario;
  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    usuarioAtivoProvider = context.read<UsuarioAtivoProvider>();
    if (widget.conversa != null) {
      final destinatarioId = widget.conversa!.participantesIds
          .firstWhere((element) => element != usuarioAtivoProvider.pessoa.id);
      destinatario = widget.pessoas[destinatarioId];
    } else {
      destinatario = null;
    }
    listenForUserChanges = profileProvider.firebaseDatabase
        .ref("${DatabaseConstants.pathUserCollection}/${widget.destinatarioId}")
        .onValue
        .listen((event) {
      setState(() {
        if (widget.conversa != null) {
          Pessoa pessoa =
              Pessoa.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
          destinatario = pessoa;
        } else {
          destinatario = null;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    listenForUserChanges.cancel();
  }

  @override
  Widget build(BuildContext context) {
    UsuarioAtivoProvider usuarioAtivoProvider =
        Provider.of<UsuarioAtivoProvider>(context);
    ConversasSelecionadasProvider selecionadas =
        Provider.of<ConversasSelecionadasProvider>(context);

    if (widget.conversa != null) {
      Conversa conversa = widget.conversa!;
      return ListTile(
        leading: destinatario == null
            ? const CircularProgressIndicator()
            : IconLeading(
                pessoa: destinatario!,
                radius: 30,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          maintainState: false,
                          builder: (context) {
                            return Provider(
                                create: (context) => UsuarioAtivoProvider(
                                    usuarioAtivoProvider.pessoa),
                                child: Profile(pessoa: destinatario!));
                          }));
                }),
        title: ConversaTitle(destinatario: destinatario),
        trailing: ConversaTrailing(conversa: conversa),
        subtitle: ConversaSubTitle(conversa: conversa),
        tileColor: Colors.grey[100],
        selectedTileColor: Colors.blue[50],
        selected: selecionadas.conversas.contains(conversa),
        onTap: destinatario == null
            ? null
            : selecionadas.conversas.isNotEmpty
                ? () => selecionadas.conversas.contains(conversa)
                    ? selecionadas.remove(conversa)
                    : selecionadas.save(conversa)
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: false,
                        builder: (BuildContext context) {
                          return MultiProvider(
                              providers: [
                                Provider<UsuarioAtivoProvider>(
                                  create: (context) => UsuarioAtivoProvider(
                                      usuarioAtivoProvider.pessoa),
                                ),
                                ChangeNotifierProvider<MensagensSelecionadas>(
                                    create: (context) =>
                                        MensagensSelecionadas())
                              ],
                              child: ConversaPage(
                                conversa: conversa,
                                destinatario: destinatario!,
                              ));
                        },
                      ),
                    );
                  },
        onLongPress: () => selecionadas.conversas.contains(conversa)
            ? selecionadas.remove(conversa)
            : selecionadas.save(conversa),
      );
    }
    return const CircularProgressIndicator();
  }
}

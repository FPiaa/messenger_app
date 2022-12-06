import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/conversa_page.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/homepage/subtitle.dart';
import 'package:messenger_app/widget/homepage/title.dart';
import 'package:messenger_app/widget/homepage/trailing.dart';
import 'package:messenger_app/widget/icon_leading.dart';
import 'package:provider/provider.dart';

class ProfileItem extends StatefulWidget {
  final Pessoa? destinatario;
  final List<Conversa> conversas;
  final Map<String, Pessoa> pessoas;
  final Function callback;
  const ProfileItem(
      {super.key,
      this.destinatario,
      required this.conversas,
      required this.pessoas,
      required this.callback});

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  @override
  Widget build(BuildContext context) {
    UsuarioAtivoProvider usuarioAtivoProvider =
        Provider.of<UsuarioAtivoProvider>(context);
    if (widget.destinatario != null) {
      if (widget.destinatario!.id == usuarioAtivoProvider.pessoa.id) {
        return const SizedBox.shrink();
      }

      return ListTile(
          leading: IconLeading(
              pessoa: widget.destinatario!,
              radius: 30,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  widget.callback();
                  return Provider(
                      create: (context) =>
                          UsuarioAtivoProvider(usuarioAtivoProvider.pessoa),
                      child: Profile(pessoa: widget.destinatario!));
                }));
              }),
          title: ConversaTitle(destinatario: widget.destinatario),
          trailing: const ConversaTrailing(conversa: null),
          subtitle: const ConversaSubTitle(conversa: null),
          tileColor: Colors.grey[100],
          selectedTileColor: Colors.blue[50],
          onTap: () {
            getOrCreateConversa(context, widget.destinatario!).then((conversa) {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  widget.callback();
                  return MultiProvider(
                      providers: [
                        Provider<UsuarioAtivoProvider>(
                          create: (context) =>
                              UsuarioAtivoProvider(usuarioAtivoProvider.pessoa),
                        ),
                        ChangeNotifierProvider<MensagensSelecionadas>(
                            create: (context) => MensagensSelecionadas())
                      ],
                      child: ConversaPage(
                          conversa: conversa,
                          destinatario: widget.destinatario!));
                },
              ));
            });
          });
    }
    return const CircularProgressIndicator();
  }

  Future<Conversa> getOrCreateConversa(BuildContext context, Pessoa p) {
    ConversaProvider conversaProvider =
        Provider.of<ConversaProvider>(context, listen: false);
    UsuarioAtivoProvider usuarioAtivoProvider =
        Provider.of<UsuarioAtivoProvider>(context, listen: false);

    if (widget.pessoas[p.id] != null) {
      return Future(() => widget.conversas
          .firstWhere((element) => element.participantesIds.contains(p.id)));
    } else {
      return conversaProvider.createConversa(
          [usuarioAtivoProvider.pessoa, p]).then((value) => value);
    }
  }
}

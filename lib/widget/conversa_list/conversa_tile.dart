import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:provider/provider.dart';

import '../../models/conversa.dart';
import '../../pages/conversa_page.dart';
import '../icon_leading.dart';

class ConversaTile extends StatelessWidget {
  final ConversasSelecionadasProvider selecionadas;
  final Conversa conversa;
  const ConversaTile({
    super.key,
    required this.conversa,
    required this.selecionadas,
  });

  @override
  Widget build(BuildContext context) {
    UsuarioAtivoProvider usuarioAtivoProvider =
        Provider.of<UsuarioAtivoProvider>(context);

    Pessoa destinatario = conversa.participantes
        .firstWhere((element) => element != usuarioAtivoProvider.pessoa);

    return ListTile(
      leading: IconLeading(
        pessoa: destinatario,
        radius: 30,
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Profile(pessoa: destinatario, isCurrentUser: false);
        })),
      ),
      title: _buildTitle(destinatario),
      trailing: _buildTrailing(),
      subtitle: _buildSubTitle(),
      tileColor: Colors.grey[200],
      selectedTileColor: Colors.blue[50],
      selected: selecionadas.conversas.contains(conversa),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MultiProvider(providers: [
            ChangeNotifierProvider<UsuarioAtivoProvider>(
              create: (context) =>
                  UsuarioAtivoProvider(usuarioAtivoProvider.pessoa),
            )
          ], child: ConversaPage(conversa: conversa));
        }));
      },
      onLongPress: () => {
        selecionadas.conversas.contains(conversa)
            ? selecionadas.remove(conversa)
            : selecionadas.save(conversa)
      },
    );
  }

  Widget _buildTitle(Pessoa destinatario) {
    return Text(
      destinatario.username,
      style: const TextStyle(fontSize: 18, overflow: TextOverflow.clip),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubTitle() {
    if (conversa.mensagens.isEmpty) {
      return Container();
    } else {
      return Text(
        conversa.mensagens.last.content,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildTrailing() {
    if (conversa.mensagens.isEmpty) {
      return const Text(" ");
    } else {
      // TODO: Formatar de acordo com a preferência do usuário
      return Text(DateFormat.jm().format(conversa.mensagens.last.dataEnvio));
    }
  }
}

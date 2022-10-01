import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../models/conversa.dart';
import '../../pages/conversa_page.dart';

//TODO: por algum motivo esquecido por deus toda hora que uma conversa
//nova é criada ela possui um hashCode diferente, mesmo sendo
//exatamente o mesmo objeto, descubra como arrumar

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
    return ListTile(
      leading: _buildLeading(),
      title: _buildTitle(),
      trailing: _buildTrailing(),
      subtitle: _buildSubTitle(),
      tileColor: Colors.grey[200],
      selectedTileColor: Colors.blue[50],
      selected: selecionadas.conversas.contains(conversa),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ConversaPage(conversa: conversa);
        }));
      },
      onLongPress: () => {
        selecionadas.conversas.contains(conversa)
            ? selecionadas.remove(conversa)
            : selecionadas.save(conversa)
      },
    );
  }

  Widget _buildLeading() {
    const double imageSize = 55.0;
    return GestureDetector(
      onTap: () => print("Imagem Pressionada"),
      child: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.transparent,
        // foregroundImage: NetworkImage('https://via.placeholder.com/150'),
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: conversa.imageUrl != null
                ? Image.asset(conversa.imageUrl!)
                : const Icon(
                    Icons.person,
                    size: imageSize,
                    color: Colors.grey,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      conversa.nome,
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

import 'package:flutter/material.dart';
import 'package:messenger_app/repository/conversas_selecionadas_repository.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';
import '../pages/conversa_page.dart';

//TODO: por algum motivo esquecido por deus toda hora que uma conversa
//nova é criada ela possui um hashCode diferente, mesmo sendo
//exatamente o mesmo objeto, descubra como arrumar
class ConversaTile extends StatefulWidget {
  Conversa conversa;
  ConversaTile({super.key, required this.conversa});

  @override
  State<ConversaTile> createState() => _ConversaTileState();
}

class _ConversaTileState extends State<ConversaTile> {
  late ConversasSelecionadasRepository selecionadas;

  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasRepository>(context);

    return ListTile(
      leading: _buildLeading(),
      title: _buildTitle(),
      trailing: _buildTrailing(),
      subtitle: _buildSubTitle(),
      tileColor: Colors.grey[200],
      selectedTileColor: Colors.blue[50],
      selected: selecionadas.conversas.contains(widget.conversa),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ConversaPage(conversa: widget.conversa);
        }));
      },
      onLongPress: () => setState(() {
        selecionadas.conversas.contains(widget.conversa)
            ? selecionadas.remove(widget.conversa)
            : selecionadas.save(widget.conversa);
      }),
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
            child: widget.conversa.imageUrl != null
                ? Image.asset(widget.conversa.imageUrl!)
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
      widget.conversa.nome,
      style: const TextStyle(fontSize: 18, overflow: TextOverflow.clip),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubTitle() {
    if (widget.conversa.mensagens.isEmpty) {
      return Container();
    } else {
      return Text(
        widget.conversa.mensagens.last.content,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildTrailing() {
    if (widget.conversa.mensagens.isEmpty) {
      return const Text(" ");
    } else {
      // TODO: Adicionar formatação bonita para as hora
      return Text("${widget.conversa.mensagens.last.dataEnvio.second}");
    }
  }
}

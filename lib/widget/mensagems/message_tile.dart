import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:provider/provider.dart';

class MessageTile extends StatefulWidget {
  final Mensagem mensagem;
  const MessageTile({super.key, required this.mensagem});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    MensagensSelecionadas mensagensSelecionadas =
        Provider.of<MensagensSelecionadas>(context);
    UsuarioAtivoProvider usuarioAtivoProvider =
        context.read<UsuarioAtivoProvider>();
    bool selecionada = mensagensSelecionadas.contains(widget.mensagem);
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: mensagensSelecionadas.mensagem.isEmpty
          ? null
          : () => mensagensSelecionadas.mensagem.contains(widget.mensagem)
              ? mensagensSelecionadas.remove(widget.mensagem)
              : mensagensSelecionadas.save(widget.mensagem),
      onLongPress: () =>
          mensagensSelecionadas.mensagem.contains(widget.mensagem)
              ? mensagensSelecionadas.remove(widget.mensagem)
              : mensagensSelecionadas.save(widget.mensagem),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: (widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
            ? (selecionada ? Colors.green[50] : Colors.white)
            : (selecionada ? Colors.green[50] : Colors.white)),
        child: Align(
          alignment: widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
              ? Alignment.topRight
              : Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  (widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
                      ? (selecionada ? Colors.blue[50] : Colors.blue[200])
                      : (selecionada ? Colors.blue[50] : Colors.grey[100])),
            ),
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 50, maxWidth: width * 0.7),
              child: Column(
                children: [
                  SelectableText(
                    widget.mensagem.content!,
                  ),
                  // TODO: alinahr o horário a direita sem mudar o tamanho da widget
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Text(
                      DateFormat.jm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.mensagem.dataEnvio)),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

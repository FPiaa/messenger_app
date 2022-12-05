import 'package:flutter/material.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/mensagems/image_tile.dart';
import 'package:messenger_app/widget/mensagems/text_tile.dart';
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: (widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
          ? (selecionada ? Colors.green[50] : null)
          : (selecionada ? Colors.green[50] : null)),
      child: Align(
        alignment: widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
            ? Alignment.topRight
            : Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 88,
            minHeight: 42,
            maxWidth: width * 0.7,
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  (widget.mensagem.remetente == usuarioAtivoProvider.pessoa.id
                      ? (selecionada
                          ? Colors.blue[50]
                          : Colors.blue.withOpacity(0.5))
                      : (selecionada
                          ? Colors.blue[50]
                          : Colors.grey.withOpacity(0.5))),
            ),
            child: InkWell(
              splashColor: Colors.amber[100],
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(20),
              enableFeedback: true,
              onTap: mensagensSelecionadas.mensagem.isEmpty
                  ? null
                  : () =>
                      mensagensSelecionadas.mensagem.contains(widget.mensagem)
                          ? mensagensSelecionadas.remove(widget.mensagem)
                          : mensagensSelecionadas.save(widget.mensagem),
              onLongPress: () =>
                  mensagensSelecionadas.mensagem.contains(widget.mensagem)
                      ? mensagensSelecionadas.remove(widget.mensagem)
                      : mensagensSelecionadas.save(widget.mensagem),
              child: widget.mensagem.type == MessageType.text
                  ? TextTile(mensagem: widget.mensagem)
                  : widget.mensagem.type == MessageType.image
                      ? ImageTile(
                          mensagem: widget.mensagem, selecionada: selecionada)
                      : SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

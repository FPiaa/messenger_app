import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:provider/provider.dart';

import '../../models/mensagem.dart';

class ListTileMensagem extends StatelessWidget {
  ListTileMensagem({
    Key? key,
    required this.mensagem,
    required this.selecionada,
  }) : super(key: key);

  final Mensagem mensagem;
  bool selecionada;
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late MensagensSelecionadas mensagensSelecionadas;
  @override
  Widget build(BuildContext context) {
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    mensagensSelecionadas = Provider.of<MensagensSelecionadas>(context);

    return GestureDetector(
      onLongPress: () {
        mensagensSelecionadas.mensagem.contains(mensagem)
            ? mensagensSelecionadas.remove(mensagem)
            : mensagensSelecionadas.save(mensagem);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: (mensagem.remetente == usuarioAtivoProvider.pessoa
            ? (selecionada ? Colors.green[50] : Colors.white)
            : (selecionada ? Colors.green[50] : Colors.white)),
        child: Align(
          alignment: mensagem.remetente == usuarioAtivoProvider.pessoa
              ? Alignment.topRight
              : Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (mensagem.remetente == usuarioAtivoProvider.pessoa
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
                    DateFormat.jm().format(mensagem.dataEnvio),
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
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/mensagem.dart';
import '../../repository/pessoa_repository.dart';

class ListTileMensagem extends StatelessWidget {
  const ListTileMensagem({
    Key? key,
    required this.mensagem,
  }) : super(key: key);

  final Mensagem mensagem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: mensagem.remetente == PessoaRepository.pessoas[0]
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (mensagem.remetente == PessoaRepository.pessoas[0]
                ? Colors.blue[200]
                : Colors.grey[200]),
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
    );
  }
}

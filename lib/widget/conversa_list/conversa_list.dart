import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:provider/provider.dart';

import 'conversa_tile.dart';

class ConversaListView extends StatefulWidget {
  final List<Conversa> conversas;
  const ConversaListView({super.key, required this.conversas});

  @override
  State<ConversaListView> createState() => _ConversaListViewState();
}

class _ConversaListViewState extends State<ConversaListView> {
  late ConversasSelecionadasProvider selecionadas =
      Provider.of<ConversasSelecionadasProvider>(context);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int conversa) => ConversaTile(
              conversa: widget.conversas[conversa],
              selecionadas: selecionadas,
            ),
        padding: const EdgeInsets.only(top: 16.0),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: widget.conversas.length);
  }
}

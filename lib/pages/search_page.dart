import 'package:flutter/material.dart';
import 'package:messenger_app/provider/conversas_pesquisadas_provider.dart';
import 'package:messenger_app/widget/conversa_list/conversa_list.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class SearchPage extends SearchDelegate {
  late ConversasPesquisadasProvider pesquisa;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    pesquisa = Provider.of<ConversasPesquisadasProvider>(context);
    List<Conversa> conversasFiltradas = pesquisa.filter((Conversa conversa) =>
        conversa.nome.toLowerCase().contains(query.toLowerCase()));

    return ConversaListView(conversas: conversasFiltradas);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    pesquisa = Provider.of<ConversasPesquisadasProvider>(context);
    List<Conversa> conversasFiltradas = pesquisa.filter((Conversa conversa) =>
        conversa.nome.toLowerCase().contains(query.toLowerCase()));

    return ConversaListView(conversas: conversasFiltradas);
  }

  @override
  String get searchFieldLabel => "Pesquisa";
}

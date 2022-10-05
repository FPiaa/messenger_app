import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/provider/conversas_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:messenger_app/widget/conversa_list/conversa_list.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class SearchPage extends SearchDelegate<Conversa?> {
  final List<Conversa> pesquisa;
  final Pessoa usuarioAtual;
  SearchPage({required this.pesquisa, required this.usuarioAtual});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.delete)),
      IconButton(
          onPressed: () {
            close(context, null);
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
    List<Conversa> conversasFiltradas = pesquisa
        .where((Conversa conversa) => conversa.participantes
            .firstWhere((element) => element != usuarioAtual)
            .username
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return MultiProvider(providers: [
      ChangeNotifierProvider<UsuarioAtivoProvider>(
          create: (context) => UsuarioAtivoProvider(usuarioAtual)),
      ChangeNotifierProvider<ConversasSelecionadasProvider>(
          create: (context) => ConversasSelecionadasProvider())
    ], child: ConversaListView(conversas: conversasFiltradas));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Conversa> conversasFiltradas = pesquisa
        .where((Conversa conversa) => conversa.participantes
            .firstWhere((element) => element != usuarioAtual)
            .username
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return MultiProvider(providers: [
      ChangeNotifierProvider<UsuarioAtivoProvider>(
          create: (context) => UsuarioAtivoProvider(usuarioAtual)),
      ChangeNotifierProvider<ConversasSelecionadasProvider>(
          create: (context) => ConversasSelecionadasProvider())
    ], child: ConversaListView(conversas: conversasFiltradas));
  }

  @override
  String get searchFieldLabel => "Pesquisa";
}

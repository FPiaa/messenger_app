import 'package:flutter/material.dart';
import 'package:messenger_app/pages/search_page.dart';
import 'package:messenger_app/provider/conversas_pesquisadas_provider.dart';
import 'package:messenger_app/repository/conversas_repository.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/widget/conversa_list/conversa_list.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConversasSelecionadasProvider selecionadas;
  late ConversasPesquisadasProvider pesquisadas;
  static List<Conversa> conversas = ConversaRepository().init();

  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    pesquisadas = Provider.of<ConversasPesquisadasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: selecionadas.conversas.isEmpty
            ? const Text("Anti-Zuk")
            : Text("${selecionadas.conversas.length} conversas"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              pesquisadas.init(conversas);
              showSearch(context: context, delegate: SearchPage());
            },
            icon: const Icon(Icons.search),
          ),
          //TODO: trocar para popMenuButtom
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: (() => print("foo")),
            tooltip: "opções",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => {}),
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      body: ConversaListView(conversas: conversas),
    );
  }
}

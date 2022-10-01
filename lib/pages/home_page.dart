import 'package:flutter/material.dart';
import 'package:messenger_app/repository/conversas_repository.dart';
import 'package:messenger_app/repository/conversas_selecionadas_repository.dart';
import 'package:messenger_app/widget/conversa_tile.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConversasSelecionadasRepository selecionadas;
  static List<Conversa> conversas = ConversaRepository().init();

//TODO: remover o repositório do build
  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: selecionadas.conversas.isEmpty
            ? const Text("Anti-Zuk")
            : Text("${selecionadas.conversas.length} conversas"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => print("search pressed"),
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
      body: ListView.separated(
          itemBuilder: (BuildContext context, int conversa) => ConversaTile(
                conversa: conversas[conversa],
              ),
          padding: const EdgeInsets.only(top: 16.0),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: conversas.length),
    );
  }
}

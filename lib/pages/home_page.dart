import 'package:flutter/material.dart';
import 'package:messenger_app/controllers/conversa_controller.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/search_page.dart';
import 'package:messenger_app/provider/conversas_pesquisadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:messenger_app/repository/conversas_repository.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/repository/i_repository.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';
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
  final IRepository<Conversa> conversaRepository = ConversaRepository();
  late UsuarioAtivoProvider usuarioAtivoProvider;

  PessoaController pessoaController =
      PessoaController(pessoaRepository: PessoaRepository());
  ConversaController conversaController =
      ConversaController(conversaRepository: ConversaRepository());

  List<Conversa> query(Pessoa pessoa) {
    List<Conversa> a = conversaController
        .findAll((Conversa c) => c.participantes.contains(pessoa))
        .toList();

    return a;
  }

  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    pesquisadas = Provider.of<ConversasPesquisadasProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);

    List<Conversa> conversas = query(usuarioAtivoProvider.pessoa);

    return Scaffold(
      appBar: AppBar(
        title: selecionadas.conversas.isEmpty
            ? const Text("Anti-Zuk")
            : Text("${selecionadas.conversas.length} conversas"),
        centerTitle: false,
        actions: [
          selecionadas.conversas.isEmpty
              ? IconButton(
                  onPressed: () {
                    pesquisadas.init(conversas);
                    showSearch(context: context, delegate: SearchPage());
                  },
                  icon: const Icon(Icons.search),
                )
              : IconButton(
                  onPressed: () {
                    for (Conversa conversa in selecionadas.conversas) {
                      conversaController.delete(conversa);
                    }
                    selecionadas.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete),
                )
          //TODO: trocar para popMenuButtom
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

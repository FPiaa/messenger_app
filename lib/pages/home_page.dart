import 'package:flutter/material.dart';
import 'package:messenger_app/controllers/conversa_controller.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
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

  final textField = TextEditingController();

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

  List<Conversa> filtradas = [];
  bool filtrar = false;
  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    List<Conversa> conversas = query(usuarioAtivoProvider.pessoa);

    return Scaffold(
      appBar: buildAppBar(conversas),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => {}),
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      body: ConversaListView(
          conversas: filtradas.isEmpty ? conversas : filtradas),
    );
  }

  AppBar buildAppBar(List<Conversa> conversas) {
    if (filtrar) {
      return AppBar(
        title: TextFormField(
            autofocus: true,
            controller: textField,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                label: Text("Pesquisar..."),
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.grey),
            onChanged: (value) {
              setState(() {
                filtradas = conversas
                    .where((element) => element
                        .getName(usuarioAtivoProvider.pessoa)
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              textField.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
              onPressed: () {
                filtradas.clear();
                textField.clear();
                setState(() {
                  filtrar = false;
                });
              },
              icon: const Icon(Icons.cancel))
        ],
      );
    }
    if (selecionadas.conversas.isNotEmpty) {
      return AppBar(
        title: selecionadas.conversas.length == 1
            ? const Text("1 conversa")
            : Text("${selecionadas.conversas.length} conversas"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              for (Conversa conversa in selecionadas.conversas) {
                conversaController.delete(conversa);
              }
              selecionadas.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Profile(
                        pessoa: usuarioAtivoProvider.pessoa,
                        isCurrentUser: true)));
              },
              icon: const Icon(Icons.person))
        ],
      );
    }
    return AppBar(
      title: const Text("Meu Aplicativo"),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              filtrar = true;
            });
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(
                      pessoa: usuarioAtivoProvider.pessoa,
                      isCurrentUser: true)));
            },
            icon: const Icon(Icons.person))
      ],
    );
  }
}

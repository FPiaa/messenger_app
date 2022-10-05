import 'package:flutter/material.dart';
import 'package:messenger_app/controllers/conversa_controller.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversas_provider.dart';
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
  late ConversasProvider pesquisadas;
  final IRepository<Conversa> conversaRepository = ConversaRepository();
  late UsuarioAtivoProvider usuarioAtivoProvider;

  final textField = TextEditingController();

  PessoaController pessoaController =
      PessoaController(pessoaRepository: PessoaRepository());
  ConversaController conversaController =
      ConversaController(conversaRepository: ConversaRepository());

  List<Conversa> query(Pessoa pessoa) {
    if (contatos) {
      return conversas;
    } else {
      List<Conversa> a = conversaController
          .findAll((Conversa c) => c.participantes.contains(pessoa))
          .toList();

      return a;
    }
  }

  onPressed() {
    setState(() {
      if (!contatos) {
        contatos = true;
        conversas = conversaController
            .getContacts(usuarioAtivoProvider.pessoa)
            .toList();
      } else {
        contatos = false;
        conversas = query(usuarioAtivoProvider.pessoa);
      }
    });
  }

  late List<Conversa> conversas;
  List<Conversa> filtradas = [];
  bool filtrar = false;
  bool contatos = false;
  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    //TODO: remover essa conversa do build
    conversas = query(usuarioAtivoProvider.pessoa);

    return Scaffold(
      appBar: buildAppBar(conversas),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      body: ConversaListView(
        conversas: filtrar && filtradas.isNotEmpty ? filtradas : conversas,
      ),
    );
  }

  AppBar buildAppBar(List<Conversa> conversas) {
    if (filtrar) {
      return AppBar(
        title: TextFormField(
            cursorColor: Colors.black87,
            cursorWidth: 1,
            autofocus: true,
            controller: textField,
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                label: contatos
                    ? const Text("Pesquisar contatos...")
                    : const Text("Pesquisar..."),
                labelStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.grey),
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  filtradas = [];
                } else {
                  filtradas = conversas
                      .where((element) => element
                          .getName(usuarioAtivoProvider.pessoa)
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                }
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
        ],
      );
    }
    return AppBar(
      title:
          contatos ? const Text("Meus contatos") : const Text("Meu Aplicativo"),
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

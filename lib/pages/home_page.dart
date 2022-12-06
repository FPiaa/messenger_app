import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/widget/homepage/conversa_item.dart';
import 'package:messenger_app/widget/homepage/profile_item.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConversasSelecionadasProvider selecionadas;
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late ProfileProvider profileProvider;
  late ConversaProvider conversaProvider;
  List<Conversa> conversas = [];
  List<Conversa> filtradas = [];
  Map<String, Pessoa> pessoas = {};
  bool filtrar = false;
  bool contatos = false;

  late StreamSubscription<DatabaseEvent> listenForConversas;
  final textField = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    conversaProvider = context.read<ConversaProvider>();
    usuarioAtivoProvider = context.read<UsuarioAtivoProvider>();
    listenForConversas = conversaProvider.firebaseDatabase
        .ref(DatabaseConstants.pathConversaCollection)
        .onValue
        .listen((event) async {
      conversas = await conversaProvider.getConversasWith(
          pessoa: usuarioAtivoProvider.pessoa);
      conversas.sort((Conversa m1, Conversa m2) =>
          //totalmente ok fazer a checagem incondicional, quando a conversa é criada no BD,
          // ela vai possuir a data de horario como sendo a data de criação da conversa
          m2.horarioUltimaMensagem!.compareTo(m1.horarioUltimaMensagem!));

      pessoas.clear();
      for (Conversa c in conversas) {
        final id = c.participantesIds
            .firstWhere((element) => element != usuarioAtivoProvider.pessoa.id);
        final data = await profileProvider.getProfile(id: id);
        if (data.value != null) {
          pessoas[id] = Pessoa.fromJson(data.value as Map<dynamic, dynamic>);
        }
      }
      if (!contatos) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    listenForConversas.cancel();
  }

  onFloatingButtonPressed() {
    setState(() {
      if (!contatos) {
        clearState();
        contatos = true;
      } else {
        contatos = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);

    return Scaffold(
      appBar: buildAppBar(conversas),
      floatingActionButton: FloatingActionButton(
        onPressed: onFloatingButtonPressed,
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      body: buildListView(),
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
                  filtradas = conversas.where((element) {
                    final destinatarioId = element.participantesIds.firstWhere(
                        (element) => element != usuarioAtivoProvider.pessoa.id);
                    final pessoa = pessoas[destinatarioId];
                    if (pessoa == null) {
                      return false;
                    }
                    return element.participantesIds.contains(pessoa.id);
                  }).toList();
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
                clearState();
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
                conversaProvider.deleteConversa(conversa: conversa);
              }
              selecionadas.clear();
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
        contatos
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  setState(() {
                    filtrar = true;
                  });
                },
                icon: const Icon(Icons.search),
              ),
        IconButton(
            onPressed: () {
              clearState();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Provider(
                    create: ((context) =>
                        UsuarioAtivoProvider(usuarioAtivoProvider.pessoa)),
                    child: Profile(pessoa: usuarioAtivoProvider.pessoa));
              }));
            },
            icon: const Icon(Icons.person))
      ],
    );
  }

  Widget buildListView() {
    if (contatos) {
      return StreamBuilder<DataSnapshot>(
          stream: profileProvider.getProfiles(limit: 30),
          builder: ((context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final pessoasA = snapshot.data!.children.toList();
              return ListView.separated(
                  itemBuilder: (context, data) {
                    if (pessoasA[data].value != null) {
                      final pessoa = Pessoa.fromJson(
                          pessoasA[data].value as Map<dynamic, dynamic>);
                      return ProfileItem(
                        conversas: conversas,
                        destinatario: pessoa,
                        callback: clearState,
                        pessoas: pessoas,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: pessoasA.length);
            } else {
              return const Center(
                child: Text("No user found"),
              );
            }
          }));
    } else {
      if (conversas.isEmpty) {
        return Container();
      }
      if (filtrar) {
        return ListView.separated(
            itemBuilder: (context, data) =>
                ConversaItem(conversa: filtradas[data], pessoas: pessoas),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: filtradas.length);
      } else {
        return ListView.separated(
            itemBuilder: (context, data) => ConversaItem(
                  conversa: conversas[data],
                  pessoas: pessoas,
                ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: conversas.length);
      }
    }
  }

  clearState() {
    selecionadas.empty();
    filtradas.clear();
    pessoas.clear();
    filtrar = false;
    contatos = false;
  }

  Future<Conversa> getOrCreateConversa(BuildContext context, Pessoa p) {
    if (pessoas[p.id] != null) {
      return Future(() => conversas
          .firstWhere((element) => element.participantesIds.contains(p.id)));
    } else {
      return conversaProvider.createConversa(
          [usuarioAtivoProvider.pessoa, p]).then((value) => value);
    }
  }
}

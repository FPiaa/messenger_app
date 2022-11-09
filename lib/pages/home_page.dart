import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/controllers/conversa_controller.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/conversas_provider.dart';
import 'package:messenger_app/provider/mensagens_selecionadas_provider.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/repository/conversas_repository.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/repository/i_repository.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';
import 'package:provider/provider.dart';

import '../models/conversa.dart';
import '../widget/icon_leading.dart';
import 'conversa_page.dart';

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
  late ProfileProvider profileProvider;
  late ConversaProvider conversaProvider;

  final textField = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    conversaProvider = context.read<ConversaProvider>();
    FirebaseDatabase.instance
        .ref(DatabaseConstants.pathConversaCollection)
        .onValue
        .listen((event) async {
      conversas = await conversaProvider.getConversasWith(
          pessoa: usuarioAtivoProvider.pessoa);
      if (!contatos) {
        setState(() {});
      }
    });
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

  List<Conversa> conversas = [];
  List<Conversa> filtradas = [];
  bool filtrar = false;
  bool contatos = false;
  @override
  Widget build(BuildContext context) {
    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);

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
                  filtradas = [];
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
                //TODO : deletar conversa
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
          stream: profileProvider.getProfiles(limit: 10),
          builder: ((context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final pessoas = snapshot.data!.children.toList();
              return ListView.separated(
                  itemBuilder: (context, data) {
                    if (pessoas[data].value != null &&
                        pessoas[data].children.length == 4) {
                      final pessoa = Pessoa.fromJson(
                          pessoas[data].value as Map<dynamic, dynamic>);
                      return buildProfileItem(context, pessoa);
                    }
                    return const SizedBox.shrink();
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: pessoas.length);
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
      return ListView.separated(
          itemBuilder: (context, data) =>
              buildConversaItem(context, conversas[data]),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: conversas.length);
    }
  }

  Widget buildProfileItem(BuildContext context, Pessoa? data) {
    if (data != null) {
      Pessoa destinatario = data;
      print(destinatario.toString());
      if (destinatario.id == usuarioAtivoProvider.pessoa.id) {
        return const SizedBox.shrink();
      }

      return ListTile(
          leading: IconLeading(
              pessoa: destinatario,
              radius: 30,
              onTap: () {
                clearState();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Provider(
                      create: (context) =>
                          UsuarioAtivoProvider(usuarioAtivoProvider.pessoa),
                      child: Profile(pessoa: destinatario));
                }));
              }),
          title: _buildTitle(destinatario),
          trailing: _buildTrailing(null),
          subtitle: _buildSubTitle(null),
          tileColor: Colors.grey[100],
          selectedTileColor: Colors.blue[50],
          onTap: () {
            createConversa(destinatario).then((conversa) {
              clearState();
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return MultiProvider(
                      providers: [
                        Provider<UsuarioAtivoProvider>(
                          create: (context) =>
                              UsuarioAtivoProvider(usuarioAtivoProvider.pessoa),
                        ),
                        ChangeNotifierProvider<MensagensSelecionadas>(
                            create: (context) => MensagensSelecionadas())
                      ],
                      child: ConversaPage(
                          conversa: conversa, destinatario: destinatario));
                },
              ));
            });
          });
    }
    print("a");
    return CircularProgressIndicator();
  }

  Widget buildConversaItem(BuildContext context, Conversa? data) {
    if (data != null) {
      Conversa conversa = data;
      final String destinatarioId = conversa.participantesIds
          .firstWhere((element) => element != usuarioAtivoProvider.pessoa.id);
      if (destinatarioId == usuarioAtivoProvider.pessoa.id) {
        return const SizedBox.shrink();
      }

      return FutureBuilder(
          future: profileProvider.getProfile(id: destinatarioId),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final destinatario = Pessoa.fromJson(
                  snapshot.data!.value as Map<dynamic, dynamic>);
              return ListTile(
                  leading: IconLeading(
                      pessoa: destinatario,
                      radius: 30,
                      onTap: () {
                        clearState();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Provider(
                              create: (context) => UsuarioAtivoProvider(
                                  usuarioAtivoProvider.pessoa),
                              child: Profile(pessoa: destinatario));
                        }));
                      }),
                  title: _buildTitle(destinatario),
                  trailing: _buildTrailing(conversa),
                  subtitle: _buildSubTitle(conversa),
                  tileColor: Colors.grey[100],
                  selectedTileColor: Colors.blue[50],
                  onTap: () {
                    clearState();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MultiProvider(
                            providers: [
                              Provider<UsuarioAtivoProvider>(
                                create: (context) => UsuarioAtivoProvider(
                                    usuarioAtivoProvider.pessoa),
                              ),
                              ChangeNotifierProvider<MensagensSelecionadas>(
                                  create: (context) => MensagensSelecionadas())
                            ],
                            child: ConversaPage(
                              conversa: conversa,
                              destinatario: destinatario,
                            ));
                      },
                    ));
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }));
    }
    print("a");
    return CircularProgressIndicator();
  }

  Widget _buildTitle(Pessoa destinatario) {
    return Text(
      destinatario.username,
      style: const TextStyle(fontSize: 20, overflow: TextOverflow.clip),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubTitle(Conversa? conversa) {
    if (conversa == null || conversa.conteudoUltimaMensagem == null) {
      return Container();
    } else {
      return Text(
        conversa.conteudoUltimaMensagem!,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildTrailing(Conversa? conversa) {
    if (conversa == null || conversa.horarioUltimaMensagem == null) {
      return const Text(" ");
    } else {
      // TODO: Formatar de acordo com a preferência do usuário
      return Text(DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
          conversa.horarioUltimaMensagem!)));
    }
  }

  Future<Conversa> createConversa(Pessoa p) {
    return conversaProvider.createConversa(
        [usuarioAtivoProvider.pessoa, p]).then((value) => value);
  }

  clearState() {
    setState(() {
      selecionadas.empty();
      filtradas.clear();
      filtrar = false;
    });
  }
}

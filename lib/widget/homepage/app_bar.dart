import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:provider/provider.dart';

class HomePageAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool filtrar;
  final bool contatos;
  final List<Conversa> conversas;
  final List<Conversa> filtradas;
  final Map<String, Pessoa> pessoas;
  final Function clearState;
  const HomePageAppBar(
      {super.key,
      required this.filtrar,
      required this.conversas,
      required this.filtradas,
      required this.pessoas,
      required this.clearState,
      required this.contatos});

  @override
  State<HomePageAppBar> createState() => _HomePageAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, 60);
}

class _HomePageAppBarState extends State<HomePageAppBar> {
  final textField = TextEditingController();
  late ConversasSelecionadasProvider selecionadas;
  late UsuarioAtivoProvider usuarioAtivoProvider;
  late final bool filtrar;
  late final bool contatos;
  late final List<Conversa> conversas;
  late final List<Conversa> filtradas;
  late final Map<String, Pessoa> pessoas;
  @override
  Widget build(BuildContext context) {
    bool contatos = widget.contatos;
    List<Conversa> conversas = widget.conversas;
    Map<String, Pessoa> pessoas = widget.pessoas;

    selecionadas = Provider.of<ConversasSelecionadasProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    ConversaProvider conversaProvider = Provider.of<ConversaProvider>(context);
    if (widget.filtrar) {
      return AppBar(
        title: TextFormField(
            cursorColor: Colors.black87,
            cursorWidth: 1,
            autofocus: true,
            controller: textField,
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                label: widget.contatos
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
                widget.clearState();
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
              widget.clearState();
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
}

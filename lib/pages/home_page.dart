import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/pages/conversa_page.dart';
import 'package:messenger_app/repository/conversas_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _conversas = ConversaRepository();
    _conversas.init();
    final conversas = _conversas.conversas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anti-Zuk"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => {}),
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int conversa) {
            return ListTile(
// TODO: Create a widget for chat Icon
              leading: conversas[conversa].imageUrl != null
                  ? Image.asset(
                      conversas[conversa].imageUrl!,
                    )
                  : const Icon(Icons.person),
              title: Text(
                conversas[conversa].nome,
              ),
              trailing: conversas[conversa].mensagens.isNotEmpty
                  ? Text(
                      "${conversas[conversa].mensagens.last.dataEnvio.second}")
                  : const Text(" "),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ConversaPage(conversa: conversas[conversa]);
                }));
              },
            );
          },
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: conversas.length),
    );
  }
}

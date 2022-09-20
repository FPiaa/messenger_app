import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pessoas = PessoaRepository.pessoas;

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
          itemBuilder: (BuildContext context, int pessoa) {
            return ListTile(
// TODO: Create a widget for chat Icon
              leading: pessoas[pessoa].photo != null
                  ? Image.asset(
                      pessoas[pessoa].photo!,
                    )
                  : const Icon(Icons.person),
              title: Text(
                pessoas[pessoa].name,
              ),
              trailing: const Text("Blah"),
            );
          },
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (_, __) => Divider(),
          itemCount: pessoas.length),
    );
  }
}

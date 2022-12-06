import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/homepage/conversa_item.dart';
import 'package:messenger_app/widget/homepage/profile_item.dart';
import 'package:provider/provider.dart';

class ListItems extends StatelessWidget {
  final bool contatos;
  final bool filtrar;
  final List<Conversa> conversas;
  final List<Conversa> filtradas;
  final Map<String, Pessoa> pessoas;
  final Function clearState;
  const ListItems(
      {super.key,
      required this.contatos,
      required this.filtrar,
      required this.conversas,
      required this.filtradas,
      required this.pessoas,
      required this.clearState});

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    UsuarioAtivoProvider usuarioAtivoProvider =
        Provider.of<UsuarioAtivoProvider>(context);
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
            itemBuilder: (context, data) => ConversaItem(
                  conversa: filtradas[data],
                  pessoas: pessoas,
                  destinatarioId: filtradas[data]
                      .destinatarioId(usuarioAtivoProvider.pessoa.id),
                ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: filtradas.length);
      } else {
        return ListView.separated(
            itemBuilder: (context, data) => ConversaItem(
                  conversa: conversas[data],
                  pessoas: pessoas,
                  destinatarioId: conversas[data]
                      .destinatarioId(usuarioAtivoProvider.pessoa.id),
                ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: conversas.length);
      }
    }
  }
}

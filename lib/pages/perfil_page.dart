import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:messenger_app/widget/profile/read_profile.dart';
import 'package:messenger_app/widget/profile/usuario_ativo_profile.dart';
import 'package:provider/provider.dart';

enum DescriptionStatus {
  reading,
  editing,
  updating,
}

class Profile extends StatefulWidget {
  const Profile({super.key, required this.pessoa});
  final Pessoa pessoa;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UsuarioAtivoProvider usuarioAtivoProvider;
  @override
  Widget build(BuildContext context) {
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil"),
        ),
        body: widget.pessoa.id.compareTo(usuarioAtivoProvider.pessoa.id) == 0
            ? ActiveUserProfile(pessoa: widget.pessoa)
            : ReadOnlyProfile(pessoa: widget.pessoa));
  }
}

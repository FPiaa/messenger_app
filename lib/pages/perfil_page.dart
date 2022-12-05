import 'dart:async';

import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
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
  late ProfileProvider profileProvider;
  late Pessoa pessoa;
  late StreamSubscription<DatabaseEvent> listenForUserChange;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    usuarioAtivoProvider = context.read<UsuarioAtivoProvider>();
    pessoa = widget.pessoa;
    if (usuarioAtivoProvider.pessoa.id.compareTo(widget.pessoa.id) != 0) {
      isListening = true;
      listenForUserChange = profileProvider.firebaseDatabase
          .ref("${DatabaseConstants.pathUserCollection}/${pessoa.id}")
          .onValue
          .listen((event) async {
        final response = await profileProvider.getProfile(id: pessoa.id);
        pessoa = Pessoa.fromJson(response.value as Map<dynamic, dynamic>);
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) {
      listenForUserChange.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil"),
        ),
        body: widget.pessoa.id.compareTo(usuarioAtivoProvider.pessoa.id) == 0
            ? ActiveUserProfile(pessoa: pessoa)
            : ReadOnlyProfile(pessoa: pessoa));
  }
}

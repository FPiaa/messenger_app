import 'package:flutter/material.dart';
import 'package:messenger_app/pages/cadastro_page.dart';
import 'package:messenger_app/pages/home_page.dart';
import 'package:messenger_app/provider/conversas_pesquisadas_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // debugPaintPointersEnabled = true;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ConversasSelecionadasProvider>(
          create: (context) => ConversasSelecionadasProvider()),
      ChangeNotifierProvider<ConversasPesquisadasProvider>(
          create: (context) => ConversasPesquisadasProvider()),
    ],
    child: const Chat(),
  ));
}

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anti-Zuk",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const CadastroPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:messenger_app/pages/home_page.dart';
import 'package:messenger_app/repository/conversas_selecionadas_repository.dart';
import 'package:provider/provider.dart';

void main() {
  // debugPaintPointersEnabled = true;
  runApp(ChangeNotifierProvider(
    create: (context) => ConversasSelecionadasRepository(),
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
      home: const HomePage(),
    );
  }
}

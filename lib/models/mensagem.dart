import 'package:messenger_app/models/pessoa.dart';

class Mensagem {
  final String content;
  final Pessoa remetente;
  final String? imageUrl;
  late final DateTime dataEnvio;

  Mensagem({
    required this.remetente,
    required this.content,
    this.imageUrl,
  }) {
    dataEnvio = DateTime.now();
  }
}

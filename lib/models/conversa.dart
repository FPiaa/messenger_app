import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';

//TODO: Fazer conversa virar classes abstrata e ter uma instanciação para grupo
// e para conversa ponto a ponto
class Conversa {
  List<Pessoa> participantes;
  List<Mensagem> mensagens;
  //Adm só é necessário para grupos
  List<Pessoa>? administradores;
  String nome;
  String? imageUrl;

  Conversa({
    required this.participantes,
    this.administradores,
    required this.nome,
    this.imageUrl,
    required this.mensagens,
  });

  //TODO: Error handling
  addMessage(Mensagem message) {
    mensagens.add(message);
  }
}

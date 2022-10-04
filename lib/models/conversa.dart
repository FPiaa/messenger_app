import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';

//TODO: Fazer conversa virar classes abstrata e ter uma instanciação para grupo
// e para conversa ponto a ponto
class Conversa {
  List<Pessoa> participantes;
  List<Mensagem> mensagens;
  //Adm só é necessário para grupos

  Conversa({
    required this.participantes,
    required this.mensagens,
  });

  //TODO: Error handling
  addMessage(Mensagem message) {
    mensagens.add(message);
  }
}

import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';

class ConversaRepository {
  static List<Pessoa> pessoas = PessoaRepository.pessoas;
  late List<Conversa> conversas = [];

  ConversaRepository() {
    conversas.add(Conversa(
        participantes: [pessoas[0], pessoas[1]],
        nome: pessoas[1].username,
        imageUrl: pessoas[1].photo));
    conversas.add(Conversa(
        participantes: pessoas,
        administradores: [pessoas[1], pessoas[2]],
        nome: "Grupo dos amigo",
        imageUrl: "images/bezos_chapeu.jpg"));
    conversas.add(Conversa(participantes: pessoas, nome: "Grupo sem nada"));
  }

  init() {
    conversas[0].addMessage(Mensagem(
      remetente: pessoas[1],
      content: "primeira mensagem",
    ));
    conversas[0].addMessage(Mensagem(
      remetente: pessoas[0],
      content: "primeira mensagem",
    ));
    conversas[0].addMessage(Mensagem(
      remetente: pessoas[1],
      content: "mensagem mensagem genérica",
    ));
    conversas[0].addMessage(Mensagem(
      remetente: pessoas[0],
      content: "resposta a mensagem genérica",
    ));
    conversas[1].addMessage(Mensagem(remetente: pessoas[2], content: "Foo"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[1], content: "BAr"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[2], content: "BAz"));
    conversas[1]
        .addMessage(Mensagem(remetente: pessoas[2], content: "Generico"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[0], content: "Bla"));
  }
}

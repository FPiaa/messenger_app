import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/i_repository.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';

class ConversaRepository implements IRepository<Conversa> {
  static List<Pessoa> pessoas = PessoaRepository.pessoas;
  late List<Conversa> conversas = [];

  ConversaRepository() {
    conversas.add(Conversa(
        participantes: [pessoas[0], pessoas[1]],
        nome: pessoas[1].username,
        imageUrl: pessoas[1].photo));
    conversas.add(Conversa(
        participantes: [pessoas[0], pessoas[1], pessoas[2]],
        administradores: [pessoas[1], pessoas[2]],
        nome: "Grupo dos amigo",
        imageUrl: "images/bezos_chapeu.jpg"));
    conversas.add(
      Conversa(
          participantes: [pessoas[0], pessoas[1], pessoas[2]],
          administradores: [pessoas[0]],
          nome: "Grupo sem nada"),
    );
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
      content:
          "resposta a mensagem genérica com uma mensagem extremamente longa",
    ));
    conversas[1].addMessage(Mensagem(remetente: pessoas[2], content: "Foo"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[1], content: "BAr"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[2], content: "BAz"));
    conversas[1]
        .addMessage(Mensagem(remetente: pessoas[2], content: "Generico"));
    conversas[1].addMessage(Mensagem(remetente: pessoas[0], content: "Bla"));
  }

  @override
  void save(Conversa component) {
    if (conversas.any((element) => component == element)) {
      return;
    }
    conversas.add(component);
  }

  @override
  Conversa? delete(Conversa component) {
    try {
      Conversa conversa =
          conversas.firstWhere((element) => element == component);
      conversas.remove(conversa);
    } catch (e) {
      return null;
    }
  }

  @override
  Conversa? find(Conversa component) {
    try {
      return conversas.firstWhere((element) => element == component);
    } catch (E) {
      return null;
    }
  }

  @override
  Iterable<Conversa> findAll(bool Function(Conversa) predicate) {
    return conversas.where(predicate);
  }

  @override
  Conversa? findWhere(bool Function(Conversa p1) predicate) {
    try {
      return conversas.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }

  @override
  Conversa? update(Conversa component) {
    try {
      Conversa conversa =
          conversas.firstWhere((element) => element == component);
      conversa = component;
      return component;
    } catch (e) {
      return null;
    }
  }
}

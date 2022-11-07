import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/i_repository.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';

class ConversaRepository implements IRepository<Conversa> {
  static final List<Pessoa> _pessoas = PessoaRepository.pessoas;
  late List<Conversa> conversas = [
    // Conversa(participantes: [
    //   _pessoas[0],
    //   _pessoas[1]
    // ], mensagens: [
    //   Mensagem(
    //     remetente: _pessoas[1],
    //     content: "primeira mensagem",
    //   ),
    //   Mensagem(
    //     remetente: _pessoas[0],
    //     content: "primeira mensagem",
    //   ),
    //   Mensagem(
    //     remetente: _pessoas[1],
    //     content: "mensagem mensagem genérica",
    //   ),
    //   Mensagem(
    //     remetente: _pessoas[0],
    //     content:
    //         "resposta a mensagem genérica com uma mensagem extremamente longa",
    //   )
    // ]),
    // Conversa(participantes: [
    //   _pessoas[1],
    //   _pessoas[2]
    // ], mensagens: [
    //   Mensagem(remetente: _pessoas[2], content: "Foo"),
    //   Mensagem(remetente: _pessoas[1], content: "BAr"),
    //   Mensagem(remetente: _pessoas[2], content: "BAz"),
    //   Mensagem(remetente: _pessoas[2], content: "Generico"),
    // ]),
    // Conversa(participantes: [_pessoas[1], _pessoas[3]], mensagens: [])
  ];

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
      return conversa;
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

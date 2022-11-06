import 'dart:collection';

import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/i_repository.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';

import '../models/conversa.dart';

class ConversaController {
  IRepository<Conversa> conversaRepository;
  ConversaController({required this.conversaRepository});

  save(Conversa conversa) {
    conversaRepository.save(conversa);
  }

  Iterable<Conversa> findAll(bool Function(Conversa) predicate) {
    return conversaRepository.findAll(predicate);
  }

  Conversa? delete(Conversa conversa) {
    return conversaRepository.delete(conversa);
  }

  Conversa? update(Conversa conversa) {
    return conversaRepository.update(conversa);
  }

  void sendMessage(Conversa conversa, Mensagem mensagem) {
    conversa.addMessage(mensagem);
    conversa.mensagens.sort(
        (Mensagem m1, Mensagem m2) => m2.dataEnvio.compareTo(m1.dataEnvio));
  }

  void deleteMessage(Conversa conversa, Mensagem mensagem) {
    conversa.mensagens.remove(mensagem);
  }

  void deleteMessages(
      Conversa conversa, UnmodifiableListView<Mensagem> mensagem) {
    for (var element in mensagem) {
      deleteMessage(conversa, element);
    }
  }

  Iterable<Conversa> getContacts(Pessoa pessoa) {
    List<Conversa> conversas = conversaRepository
        .findAll(((element) => element.participantes.contains(pessoa)))
        .toList();
    PessoaController pessoaController =
        PessoaController(pessoaRepository: PessoaRepository());
    Iterable<Pessoa> pessoas = pessoaController.findAll(
        (p) => !conversas.any((element) => element.participantes.contains(p)));

    List<Conversa> retorno = [];
    for (var pessoa2 in pessoas) {
      if (pessoa != pessoa2) {
        retorno.add(Conversa(participantes: [pessoa, pessoa2], mensagens: []));
      }
    }

    return retorno;
  }
}

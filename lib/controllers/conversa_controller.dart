import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/repository/i_repository.dart';

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
  }
}

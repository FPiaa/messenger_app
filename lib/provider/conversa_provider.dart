import 'package:firebase_database/firebase_database.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:uuid/uuid.dart';

class ConversaProvider {
  final FirebaseDatabase firebaseDatabase;
  ConversaProvider({required this.firebaseDatabase});

  Future<Conversa> createConversa(List<Pessoa> pessoas) async {
    String conversaId = Uuid().v4();
    final ids = pessoas.map((e) => e.id).toList();
    Conversa conversa =
        Conversa(participantesIds: ids, mensagens: [], id: conversaId);

    return conversa;
  }

  Future<List<Conversa>> getConversasWith({required Pessoa pessoa}) async {
    final conversasSnapshot = await firebaseDatabase
        .ref(DatabaseConstants.pathConversaCollection)
        .once(DatabaseEventType.value);

    List<Conversa> conversas = [];
    if (conversasSnapshot.snapshot.children.isNotEmpty) {
      for (DataSnapshot data in conversasSnapshot.snapshot.children) {
        Conversa conversa =
            Conversa.fromJson(data.value as Map<dynamic, dynamic>);
        if (conversa.participantesIds.contains(pessoa.id)) {
          final mensagens = await getMessages(conversaId: conversa.id);
          conversa.mensagens = mensagens;
        }
        conversas.add(conversa);
      }
    }
    return conversas;
  }

  Future<void> sendMessage(
      {required String conversaId, required Mensagem mensagem}) async {
    var data = await firebaseDatabase
        .ref("${DatabaseConstants.pathMessageCollection}/$conversaId")
        .push()
        .set(mensagem.toJson());
  }

  Future<List<Mensagem>> getMessages({required conversaId, int? limit}) async {
    limit ??= 50;
    final event = await firebaseDatabase
        .ref("${DatabaseConstants.pathMessageCollection}/$conversaId")
        .limitToLast(limit)
        .once(DatabaseEventType.value);
    List<Mensagem> mensagens = [];
    if (event.snapshot.children.isNotEmpty) {
      mensagens = (event.snapshot.value as Map<dynamic, dynamic>)
          .values
          .map((e) => Mensagem.fromJson(e))
          .toList()
          .reversed
          .toList();
    }

    return mensagens;
  }
}

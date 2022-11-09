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
    var data = conversa.toJson();
    data[DatabaseConstants.lastMessageTime] =
        DateTime.now().millisecondsSinceEpoch;
    data[DatabaseConstants.lastMessageContent] = "";
    await firebaseDatabase
        .ref("${DatabaseConstants.pathConversaCollection}/$conversaId")
        .set(data);
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
          conversas.add(conversa);
        }
      }
    }
    return conversas;
  }

  Future<void> sendMessage(
      {required String conversaId, required Mensagem mensagem}) async {
    var ref = firebaseDatabase
        .ref("${DatabaseConstants.pathMessageCollection}/$conversaId")
        .push();
    mensagem.id = ref.key;
    await ref.set(mensagem.toJson());
    var object = {
      DatabaseConstants.lastMessageContent: mensagem.content,
      DatabaseConstants.lastMessageTime: mensagem.dataEnvio
    };
    await firebaseDatabase
        .ref("${DatabaseConstants.pathConversaCollection}/$conversaId")
        .update(object);
  }

  Future<void> deleteMessage(
      {required String conversaId, required Mensagem mensagem}) async {
    await firebaseDatabase
        .ref(
            "${DatabaseConstants.pathMessageCollection}/$conversaId/${mensagem.id}")
        .set(null);
    final lastMessage = await getMessages(conversaId: conversaId, limit: 1);
    var object = {
      DatabaseConstants.lastMessageContent: null,
      DatabaseConstants.lastMessageTime: null
    };
    if (lastMessage.isNotEmpty) {
      final object = {
        DatabaseConstants.lastMessageContent: lastMessage[0].content,
        DatabaseConstants.lastMessageTime: lastMessage[0].dataEnvio
      };
      firebaseDatabase
          .ref("${DatabaseConstants.pathConversaCollection}/$conversaId")
          .update(object);
    } else {
      firebaseDatabase
          .ref("${DatabaseConstants.pathConversaCollection}/$conversaId")
          .update(object);
    }
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

  void deleteConversa({required Conversa conversa}) {
    firebaseDatabase
        .ref("${DatabaseConstants.pathConversaCollection}/${conversa.id}")
        .set(null);
    firebaseDatabase
        .ref("${DatabaseConstants.pathMessageCollection}/${conversa.id}")
        .set(null);
  }
}

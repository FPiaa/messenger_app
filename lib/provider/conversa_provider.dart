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
          final mensagensSnapshot = await firebaseDatabase
              .ref("${DatabaseConstants.pathMessageCollection}/${conversa.id}")
              .limitToLast(50)
              .once(DatabaseEventType.value);
          print("pauta pro breakpoint");
          if (mensagensSnapshot.snapshot.children.isNotEmpty) {
            final mensagens =
                (mensagensSnapshot.snapshot.value as List<dynamic>)
                    .map((e) => Mensagem.fromJson(e))
                    .toList();
            conversa.mensagens = mensagens;
          }
          conversas.add(conversa);
        }
      }
    }
    return conversas;
  }
}

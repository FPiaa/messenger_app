import 'package:firebase_database/firebase_database.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:uuid/uuid.dart';

class ConversaProvider {
  final FirebaseDatabase firebaseDatabase;
  ConversaProvider({required this.firebaseDatabase});

  // Stream<DataSnapshot> getConversas(Pessoa p) {
  //   firebaseDatabase.ref(DatabaseConstants.pathConversaCollection)
  //   .child(DatabaseConstants)
  // }

  Future<Conversa> createConversa(List<Pessoa> pessoas) async {
    String conversaId = Uuid().v4();
    final ids = pessoas.map((e) => e.id).toList();
    Conversa conversa =
        Conversa(participantesIds: ids, mensagens: [], id: conversaId);

    await firebaseDatabase
        .ref("${DatabaseConstants.pathConversaCollection}/$conversaId")
        .set(conversa.toJson());
    return conversa;
  }

  // Future<Conversa> getConversaWith(
  //     {required Pessoa pessoa, required Pessoa ativo}) async {
  //   final data = firebaseDatabase
  //       .collection(DatabaseConstants.pathConversaCollection)
  //       .where('id')
  // }
}

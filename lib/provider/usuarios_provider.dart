import 'package:firebase_database/firebase_database.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';

class UsuariosProvider {
  final FirebaseDatabase firebaseDatabase;

  UsuariosProvider({required this.firebaseDatabase});

  Stream<DataSnapshot> getUsers({required int limit, String? search}) {
    if (search != null && search.isNotEmpty) {
      return firebaseDatabase
          .ref(DatabaseConstants.pathUserCollection)
          .limitToLast(limit)
          .get()
          .asStream();
    } else {
      return firebaseDatabase
          .ref(DatabaseConstants.pathUserCollection)
          .limitToFirst(limit)
          .get()
          .asStream();
    }
  }
}

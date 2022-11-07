import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final SharedPreferences preferences;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.firebaseDatabase,
    required this.preferences,
  });

  String? getUserId() {
    return preferences.getString(DatabaseConstants.id);
  }

  Future<bool> isLogged() async {
    User? user = await firebaseAuth.currentUser;
    if (user != null) {
      if (preferences.getString(DatabaseConstants.id)?.isNotEmpty == true) {
        return true;
      }
    }
    return false;
  }

  Future<bool> handleSignIn({
    required String email,
    required String password,
  }) async {
    _status = Status.authenticating;
    notifyListeners();

    late final UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Todas as exceções vão gerar a mesma mensagem de erro para o usuário
      // "Usuário ou senha inválidos"
      print(e);
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    User? user = userCredential.user;

    if (user == null) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    final DataSnapshot result = await firebaseDatabase
        .ref("${DatabaseConstants.pathUserCollection}/${user.uid}")
        .get();

    if (!result.exists) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    Pessoa p = Pessoa.fromJson(result.value as Map<String, dynamic>);
    await preferences.setString(DatabaseConstants.id, p.id);
    await preferences.setString(DatabaseConstants.username, p.username);
    await preferences.setString(DatabaseConstants.photo, p.photo ?? "");
    await preferences.setString(DatabaseConstants.descricao, p.descricao ?? "");
    await preferences.setString(
        DatabaseConstants.dataNascimento, p.dataNascimento.toIso8601String());
    _status = Status.authenticated;
    notifyListeners();
    return true;
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
  }
}

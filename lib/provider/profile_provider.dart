import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseStorage firebaseStorage;
  final SharedPreferences preferences;

  ProfileProvider({
    required this.firebaseAuth,
    required this.firebaseDatabase,
    required this.preferences,
    required this.firebaseStorage,
  });

  String? getPrefs(String key) {
    return preferences.getString(key);
  }

  Future<bool> setPrefs({
    required String key,
    required String value,
  }) async {
    return await preferences.setString(key, value);
  }

  Future<void> updateProfile(Pessoa pessoa) async {
    final String? id = preferences.getString(DatabaseConstants.id);
    if (id == null) {
      print("O id na hora de atualizar é nulo, isso nunca deverá ocorrer");
    }
    await firebaseDatabase
        .ref("${DatabaseConstants.pathUserCollection}/$id")
        .set(pessoa.toJson());
  }

  UploadTask uploadImage({required File image, required String name}) {
    return firebaseStorage
        .ref(DatabaseConstants.pathUserImage)
        .child(name)
        .putFile(image);
  }

  Future<void> createProfile({
    required Pessoa pessoa,
  }) async {
    await firebaseDatabase
        .ref("${DatabaseConstants.pathUserCollection}/${pessoa.id}")
        .set(pessoa.toJson());
  }

  Stream<DataSnapshot> getProfiles({required int limit, String? search}) {
    if (search != null && search.isNotEmpty) {
      return firebaseDatabase
          .ref(DatabaseConstants.pathUserCollection)
          .child(DatabaseConstants.username)
          .equalTo(search)
          // .startAt("${DatabaseConstants.email}/$search")
          // .endAt("${DatabaseConstants.email}/$search~")
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

  Future<DataSnapshot> getProfile({required String id}) async {
    return firebaseDatabase
        .ref("${DatabaseConstants.pathUserCollection}/$id")
        .get();
  }
}

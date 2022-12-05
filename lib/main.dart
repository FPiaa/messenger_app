import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:messenger_app/pages/login_page.dart';
import 'package:messenger_app/provider/auth_provider.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // por motivos totalmente desconhecidos o firebase está sendo inicializado
  // duas vezes, mesmo este sendo o único momento de inicialização
  // Existe outro lugar que é chamado, na docString de firebase_options.dart
  // mas não é executado em lugar nenhum
  // ?????????????????????????????? ¯\_(ツ)_/¯
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("$e");
    print("${Firebase.apps.length}");
  }
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
    FirebaseDatabase.instance.useDatabaseEmulator("10.0.2.2", 9000);
    FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
  }

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  // debugPaintPointersEnabled = true;
  runApp(Chat(
    preferences: preferences,
  ));
}

class Chat extends StatelessWidget {
  Chat({super.key, required this.preferences});
  final SharedPreferences preferences;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    // firebaseDatabase.setPersistenceEnabled(true);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: ((context) => AuthProvider(
                firebaseAuth: firebaseAuth,
                firebaseDatabase: firebaseDatabase,
                preferences: preferences))),
        Provider<ProfileProvider>(
          create: (context) => ProfileProvider(
              firebaseAuth: firebaseAuth,
              firebaseDatabase: firebaseDatabase,
              preferences: preferences,
              firebaseStorage: firebaseStorage),
        ),
        Provider<ConversaProvider>(
          create: (context) => ConversaProvider(
            firebaseDatabase: firebaseDatabase,
            firebaseStorage: firebaseStorage,
          ),
        )
      ],
      child: MaterialApp(
        title: "Anti-Zuk",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/cadastro_page.dart';
import 'package:messenger_app/pages/home_page.dart';
import 'package:messenger_app/provider/auth_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _loginErrorMessage = "Email ou senha incorretos";
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late UsuarioAtivoProvider user;
  bool obscureText = true;
  bool ignoreValidation = true;
  late AuthProvider authProvider;

  onLogin({required String email, required String password}) async {
    if (_formKey.currentState!.validate()) {
      bool success =
          await authProvider.handleSignIn(email: email, password: password);

      if (success) {
        clearState();
        SharedPreferences preferences = authProvider.preferences;
        String id = authProvider.getUserId()!;
        Pessoa p = Pessoa(
            id: id,
            dataNascimento: DateTime.parse(
                preferences.get(DatabaseConstants.dataNascimento) as String),
            email: preferences.get(DatabaseConstants.email) as String,
            username: preferences.get(DatabaseConstants.username) as String,
            descricao: preferences.get(DatabaseConstants.descricao) as String,
            photo: preferences.get(DatabaseConstants.photo) as String);
        navigateHomePage(p);
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 32),
                child: Center(
                  child: Text(
                    "Meu aplicativo",
                    style: TextStyle(fontSize: 32, color: Colors.amber),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Center(
                  child: Image.asset("images/splash.png"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (ignoreValidation) {
                              return null;
                            }
                            if (authProvider.status ==
                                Status.authenticateError) {
                              return _loginErrorMessage;
                            }
                            if (value == null) {
                              return null;
                            }
                            if (value.isEmpty) {
                              return "Por favor insira o email";
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Insira um endereço de email válido';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text(
                              "Email",
                            ),
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.mail),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Ink(
                          child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: obscureText,
                              validator: (value) {
                                if (ignoreValidation) {
                                  ignoreValidation = false;
                                  return null;
                                }
                                if (authProvider.status ==
                                    Status.authenticateError) {
                                  authProvider.unitialize();
                                  return _loginErrorMessage;
                                }
                                if (value == null) {
                                  return null;
                                }
                                if (value.isEmpty) {
                                  return "Por Favor, insira a senha";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text("Senha"),
                                border: const UnderlineInputBorder(),
                                icon: const Icon(Icons.password),
                                suffixIcon: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  splashColor: Colors.amber[100],
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () => setState(() {
                                    obscureText = !obscureText;
                                  }),
                                  child: obscureText
                                      ? const Icon(Icons.light_mode)
                                      : const Icon(Icons.dark_mode),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: authProvider.status == Status.authenticating
                            ? const CircularProgressIndicator()
                            : Ink(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: Colors.amber, width: 1)),
                                child: InkWell(
                                  splashColor: Colors.amber[100],
                                  splashFactory: InkRipple.splashFactory,
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  onTap: () => onLogin(
                                      email: emailController.text,
                                      password: passwordController.text),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.check,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.amber),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Ink(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(40)),
                  width: 200,
                  height: 50,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Colors.amber[100],
                    onTap: () {
                      clearState();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CadastroPage()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Criar conta",
                        style:
                            TextStyle(fontSize: 16, color: Colors.blueAccent),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  navigateHomePage(Pessoa pessoa) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ConversasSelecionadasProvider>(
              create: (context) => ConversasSelecionadasProvider()),
          Provider<UsuarioAtivoProvider>(
              create: (context) => UsuarioAtivoProvider(pessoa))
        ],
        child: const HomePage(),
      );
    }));
  }

  clearState() {
    setState(() {
      emailController.clear();
      passwordController.clear();
      obscureText = true;
      ignoreValidation = true;
      authProvider.unitialize();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/cadastro_page.dart';
import 'package:messenger_app/pages/home_page.dart';
import 'package:messenger_app/provider/conversas_provider.dart';
import 'package:messenger_app/provider/conversas_selecionadas_provider.dart';
import 'package:messenger_app/provider/usuario_provider.dart';
import 'package:messenger_app/repository/pessoa_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final PessoaController pessoaController =
      PessoaController(pessoaRepository: PessoaRepository());
  late UsuarioAtivoProvider user;
  bool obscureText = true;
  onLogin() {
    if (_formKey.currentState!.validate()) {
      Pessoa? pessoa = pessoaController
          .findWhere((Pessoa p) => p.username == usernameController.text);
      if (pessoa == null || pessoa.password != passwordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Usuário ou senha inválidos."),
          backgroundColor: Colors.red,
        ));
        return;
      }
      passwordController.clear();
      usernameController.clear();

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ConversasSelecionadasProvider>(
                create: (context) => ConversasSelecionadasProvider()),
            ChangeNotifierProvider<ConversasProvider>(
                create: (context) => ConversasProvider()),
            ChangeNotifierProvider<UsuarioAtivoProvider>(
                create: (context) => UsuarioAtivoProvider(pessoa))
          ],
          child: const HomePage(),
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          controller: usernameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text(
                              "Nome de Usuário",
                            ),
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Ink(
                          child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: obscureText,
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
                        child: Ink(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border:
                                  Border.all(color: Colors.amber, width: 1)),
                          child: InkWell(
                            splashColor: Colors.amber[100],
                            splashFactory: InkRipple.splashFactory,
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            onTap: onLogin,
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastroPage())),
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
}

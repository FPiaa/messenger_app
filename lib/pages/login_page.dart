import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger_app/controllers/pessoa_controller.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/cadastro_page.dart';
import 'package:messenger_app/pages/conversa_page.dart';
import 'package:messenger_app/pages/home_page.dart';
import 'package:messenger_app/provider/conversas_pesquisadas_provider.dart';
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
      if (pessoa == null) {
        print("Algo deu errado");
      }

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ConversasSelecionadasProvider>(
                create: (context) => ConversasSelecionadasProvider()),
            ChangeNotifierProvider<ConversasPesquisadasProvider>(
                create: (context) => ConversasPesquisadasProvider()),
            ChangeNotifierProvider<UsuarioAtivoProvider>(
                create: (context) => UsuarioAtivoProvider(pessoa!))
          ],
          child: HomePage(),
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
                    style: TextStyle(
                      fontSize: 32,
                    ),
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
                            label: Text("Nome de Usuário"),
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              label: const Text("Senha"),
                              border: const UnderlineInputBorder(),
                              icon: const Icon(Icons.password),
                              suffixIcon: InkWell(
                                onTap: () => setState(() {
                                  obscureText = !obscureText;
                                }),
                                child: obscureText
                                    ? const Icon(Icons.light_mode)
                                    : const Icon(Icons.dark_mode),
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 36, bottom: 24),
                        height: 50,
                        width: 200,
                        // TODO fazer ficar arredondado
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: onLogin,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.check),
                                SizedBox(width: 8),
                                Text("Login")
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CadastroPage())),
                  child: const Text("Criar conta")),
            ],
          ),
        ),
      ),
    );
  }
}

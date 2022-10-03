import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger_app/pages/cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text("Senha"),
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.password),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 36, bottom: 24),
                        height: 50,
                        width: 200,
                        // TODO fazer ficar arredondado
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () => print("login"),
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

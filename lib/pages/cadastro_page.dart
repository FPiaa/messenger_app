import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

enum CadastroEstado { livre, cadastrando, falha }

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final pwController = TextEditingController();
  final pwValidationController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  DateTime? selectedDate;
  bool obscureText = true;
  late ProfileProvider profileProvider;
  CadastroEstado estado = CadastroEstado.livre;

  onCadastrar() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      List<String> user;
      try {
        user = await profileProvider.firebaseAuth
            .fetchSignInMethodsForEmail(emailController.text);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          estado = CadastroEstado.livre;
        });
        return;
      }
      if (user.isNotEmpty) {
        estado = CadastroEstado.falha;
        setState(() {});
        return;
      }
      final UserCredential credential = await profileProvider.firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: pwController.text);
      Pessoa pessoa = Pessoa(
          id: credential.user!.uid,
          username: usernameController.text,
          // password: pwController.text,
          email: emailController.text,
          dataNascimento: selectedDate!);
      await profileProvider.createProfile(pessoa: pessoa);
      clearState();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso')),
      );
    }
  }

  clearState() {
    setState(() {
      pwController.clear();
      pwValidationController.clear();
      emailController.clear();
      usernameController.clear();
      selectedDate = null;
      estado = CadastroEstado.livre;
    });
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Aplicativo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: TextFormField(
                    controller: usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Nome de usuário",
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.length < 4) {
                        return "O nome de usuário deve conter pelo menos 4 letras.";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Endereço de e-mail",
                      prefixIcon: const Icon(Icons.mail),
                    ),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "Insira um endereço de email válido.";
                      }

                      if (estado == CadastroEstado.falha) {
                        return "Este email já está em uso";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Data de nascimento",
                      prefixIcon: const Icon(Icons.calendar_month),
                    ),
                    onDateSelected: (DateTime? value) => setState(() {
                      selectedDate = value;
                    }),
                    validator: (value) {
                      var now = DateTime.now();
                      int idadeMinima = 12;
                      if (value == null) {
                        return "Insira a sua data de nascimento.";
                      }
                      if (value.isAfter(DateTime(
                          now.year - idadeMinima, now.month, now.day))) {
                        return "Você deve ter pelo menos $idadeMinima anos para utilizar este aplicativo";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    obscureText: obscureText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: pwController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            obscureText = !obscureText;
                          }),
                          child: obscureText
                              ? const Icon(Icons.light_mode)
                              : const Icon(Icons.dark_mode),
                        )),
                    validator: (value) => value!.length < 8
                        ? "A senha deve ter pelo penos 8 caracteres."
                        : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 36),
                  child: TextFormField(
                    obscureText: obscureText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    controller: pwValidationController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Confirme a Senha",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            obscureText = !obscureText;
                          }),
                          child: obscureText
                              ? const Icon(Icons.light_mode)
                              : const Icon(Icons.dark_mode),
                        )),
                    validator: (value) {
                      if (value! != pwController.value.text) {
                        return "As duas senhas devem ser iguais.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: estado == CadastroEstado.cadastrando
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.redAccent, width: 0),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              height: 50,
                              width: 150,
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: const BorderSide(
                                        color: Colors.redAccent, width: 0)),
                                onTap: clearState,
                                splashColor: Colors.red[100],
                                splashFactory: InkRipple.splashFactory,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    Text(
                                      "Apagar",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.redAccent),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Ink(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amber, width: 0),
                                  borderRadius: BorderRadius.circular(40)),
                              height: 50,
                              width: 150,
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                onTap: () {
                                  setState(
                                    () {
                                      estado = CadastroEstado.cadastrando;
                                    },
                                  );
                                  onCadastrar();
                                },
                                splashColor: Colors.amber[100],
                                splashFactory: InkRipple.splashFactory,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.check,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      "Cadastrar",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.amber),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ],
            )),
      ),
    );
  }
}

import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final pwController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  DateTime? selectedDate;

  onCadastrar() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  onLimpar() {
    pwController.clear();
    emailController.clear();
    usernameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anti-Zuk"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Nome de usuário",
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    //TODO: Validar que o nome de usuário não existe no repositório
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Endereço de e-mail",
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  validator: (value) {
                    //TODO: Validar que o email não existe no repositório
                    if (!EmailValidator.validate(value!)) {
                      return "Insira um endereço de email válido.";
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
                    if (value.isAfter(
                        DateTime(now.year - idadeMinima, now.month, now.day))) {
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
                  obscureText: true,
                  controller: pwController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Senha",
                    prefixIcon: const Icon(Icons.password),
                  ),
                  validator: (value) => value!.length < 8
                      ? "A senha deve ter pelo penos 8 caracteres."
                      : null,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Confirme a Senha",
                    prefixIcon: const Icon(Icons.password),
                  ),
                  validator: (value) {
                    if (value! != pwController.value.text) {
                      return "As duas senhas devem ser iguais.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLimpar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [Icon(Icons.delete), Text("Apagar")],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCadastrar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.check),
                            Text("Cadastrar")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
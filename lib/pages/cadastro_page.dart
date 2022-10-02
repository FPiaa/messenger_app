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
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.length < 4) {
                    return "O nome de usuário deve conter pelo menos 4 letras.";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "Insira um endereço de email válido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                controller: pwController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value!.length < 8
                    ? "A senha deve ter pelo penos 8 caracteres."
                    : null,
              ),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value! != pwController.value.text) {
                    return "As duas senhas devem ser iguais.";
                  }
                  return null;
                },
              ),
              DateTimeFormField(
                mode: DateTimeFieldPickerMode.date,
                validator: (value) {
                  var now = DateTime.now();
                  int idadeMinima = 12;
                  if (value!.isAfter(
                      DateTime(now.year - idadeMinima, now.month, now.day))) {
                    return "Você deve ter pelo menos $idadeMinima para utilizar este aplicativo";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          )),
    );
  }
}

import 'package:messenger_app/models/pessoa.dart';

class PessoaRepository {
  static List<Pessoa> pessoas = [
    Pessoa(name: "Jão"),
    Pessoa(name: "Igor", username: "piaa"),
    Pessoa(name: "Foo", username: 'bar', photo: "images/capivara.jpg"),
  ];
}

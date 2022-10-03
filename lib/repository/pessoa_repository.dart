import 'package:messenger_app/models/pessoa.dart';

class PessoaRepository {
  static List<Pessoa> pessoas = [
    Pessoa(
      username: "Jão",
      dataNascimento: DateTime.parse("1990-04-29"),
      email: "email@teste.com",
      password: "12345678",
    ),
    Pessoa(
      username: "piaa",
      dataNascimento: DateTime.parse("2000-01-09"),
      email: "fidler@alunos.utfpr.edu.br",
      photo: "images/capivara.jpg",
      password: "12345678",
    ),
    Pessoa(
      username: "Foo",
      dataNascimento: DateTime.parse("2002-05-18"),
      email: "email_esas@teste.com",
      password: "12345678",
    ),
  ];
}

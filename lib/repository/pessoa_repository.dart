import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/i_repository.dart';

class PessoaRepository implements IRepository<Pessoa> {
  static List<Pessoa> pessoas = [
    // Pessoa(
    //   username: "Jão",
    //   dataNascimento: DateTime.parse("1990-04-29"),
    //   email: "email@teste.com",
    //   password: "12345678",
    // ),
    // Pessoa(
    //   username: "piaa",
    //   dataNascimento: DateTime.parse("2000-01-09"),
    //   email: "fidler@alunos.utfpr.edu.br",
    //   photo: "images/capivara.jpg",
    //   descricao: "uia",
    //   password: "12345678",
    // ),
    // Pessoa(
    //   username: "Foo",
    //   dataNascimento: DateTime.parse("2002-05-18"),
    //   email: "email_esas@teste.com",
    //   password: "12345678",
    // ),
    // Pessoa(
    //     username: "barr",
    //     dataNascimento: DateTime.now(),
    //     email: "email@teste1.com",
    //     password: "12345678"),
  ];
  @override
  void save(Pessoa component) {
    if (pessoas.any((element) => component == element)) {
      return;
    }
    pessoas.add(component);
  }

  @override
  Pessoa? delete(Pessoa component) {
    try {
      return pessoas.firstWhere((element) => element == component);
    } catch (e) {
      return null;
    }
  }

  @override
  Pessoa? find(Pessoa component) {
    try {
      return pessoas.firstWhere((element) => element == component);
    } catch (e) {
      return null;
    }
  }

  @override
  Pessoa? findWhere(bool Function(Pessoa p1) predicate) {
    try {
      return pessoas.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }

  @override
  Iterable<Pessoa> findAll(bool Function(Pessoa) predicate) {
    return pessoas.where(predicate);
  }

  @override
  Pessoa? update(Pessoa component) {
    try {
      Pessoa pessoa = pessoas.firstWhere((element) => element == component);
      pessoa = component;
      return component;
    } catch (e) {
      return null;
    }
  }
}

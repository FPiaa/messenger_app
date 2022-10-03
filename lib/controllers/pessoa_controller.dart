import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/repository/i_repository.dart';

class PessoaController {
  IRepository<Pessoa> pessoaRepository;

  PessoaController({required this.pessoaRepository});

  //TODO: Adicionar validações
  void save(Pessoa pessoa) {
    pessoaRepository.save(pessoa);
  }

  void update(Pessoa pessoa) {
    pessoaRepository.update(pessoa);
  }

  Pessoa? find(Pessoa pessoa) {
    return pessoaRepository.find(pessoa);
  }

  Pessoa? delete(Pessoa pessoa) {
    return pessoaRepository.delete(pessoa);
  }
}

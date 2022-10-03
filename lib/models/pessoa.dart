class Pessoa {
  static int numeroConta = 1;
  final String username;
  final String email;
  final DateTime dataNascimento;
  String password;
  String? photo;
  String? descricao;
  // TODO: Adicionar suporte a uuid de verdade
  late int uuid;

  Pessoa({
    required this.username,
    required this.email,
    required this.dataNascimento,
    required this.password,
    this.photo,
    this.descricao,
  }) {
    uuid = numeroConta;
    numeroConta += 1;
  }
}

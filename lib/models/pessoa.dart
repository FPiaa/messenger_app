class Pessoa {
  static int numeroConta = 1;
  final String username;
  final String email;
  final DateTime dataNascimento;
  String? photo;
  String? descricao;
  late int uuid;

  Pessoa({
    required this.username,
    required this.email,
    required this.dataNascimento,
    this.photo,
    this.descricao,
  }) {
    uuid = numeroConta;
    numeroConta += 1;
  }
}

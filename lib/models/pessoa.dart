class Pessoa {
  static int numeroConta = 1;
  String username;
  String email;
  DateTime dataNascimento;
  String? photo;
  late int uuid;

  Pessoa({
    required this.username,
    required this.email,
    required this.dataNascimento,
    this.photo,
  }) {
    uuid = numeroConta;
    numeroConta += 1;
  }
}

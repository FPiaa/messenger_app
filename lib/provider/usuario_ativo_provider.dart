import 'package:messenger_app/models/pessoa.dart';

class UsuarioAtivoProvider {
  late Pessoa _pessoa;
  UsuarioAtivoProvider(Pessoa pessoa) {
    _pessoa = pessoa;
  }
  Pessoa get pessoa => _pessoa;
}

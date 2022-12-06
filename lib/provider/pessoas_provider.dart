import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class PessoasProvider extends ChangeNotifier {
  Map<String, Pessoa> pessoas = {};

  PessoasProvider(Map<String, Pessoa> pessoa) {
    pessoas = pessoa;
  }
}

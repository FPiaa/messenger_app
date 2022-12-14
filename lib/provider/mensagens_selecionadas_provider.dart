import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:messenger_app/models/mensagem.dart';

class MensagensSelecionadas extends ChangeNotifier {
  final List<Mensagem> _mensagem = [];
  UnmodifiableListView get mensagem => UnmodifiableListView(_mensagem);

  save(Mensagem m) {
    _mensagem.add(m);
    notifyListeners();
  }

  remove(Mensagem m) {
    _mensagem.remove(m);
    notifyListeners();
  }

  bool contains(Mensagem m) {
    return _mensagem.contains(m);
  }

  clear() {
    _mensagem.clear();
    notifyListeners();
  }
}

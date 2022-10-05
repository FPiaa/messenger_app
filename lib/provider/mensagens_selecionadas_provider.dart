import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:messenger_app/models/mensagem.dart';

class MensagensSelecionadas extends ChangeNotifier {
  List<Mensagem> _mensagem = [];
  UnmodifiableListView get mensagem => UnmodifiableListView(_mensagem);

  save(Mensagem m) {
    _mensagem.add(m);
    notifyListeners();
  }

  remove(Mensagem m) {
    _mensagem.remove(m);
    notifyListeners();
  }

  clear() {
    _mensagem.clear();
    notifyListeners();
  }
}

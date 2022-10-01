import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:messenger_app/models/conversa.dart';

class ConversasSelecionadasProvider extends ChangeNotifier {
  List<Conversa> _conversas = [];
  UnmodifiableListView get conversas => UnmodifiableListView(_conversas);

  save(Conversa conversa) {
    if (!_conversas.contains(conversa)) {
      _conversas.add(conversa);
      notifyListeners();
    }
  }

  remove(Conversa conversa) {
    _conversas.remove(conversa);
    notifyListeners();
  }

  clear() {
    _conversas.clear();
    notifyListeners();
  }
}

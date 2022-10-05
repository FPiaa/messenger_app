import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:messenger_app/models/conversa.dart';

class ConversasProvider extends ChangeNotifier {
  List<Conversa> _conversas = [];
  UnmodifiableListView get conversas => UnmodifiableListView(_conversas);

  init(List<Conversa> conversas) {
    _conversas = conversas;
    notifyListeners();
  }

  List<Conversa> filter(Function filtro) {
    return _conversas.where((element) => filtro(element)).toList();
  }
}

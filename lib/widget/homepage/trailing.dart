import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/conversa.dart';

class ConversaTrailing extends StatelessWidget {
  const ConversaTrailing({
    Key? key,
    required this.conversa,
  }) : super(key: key);

  final Conversa? conversa;

  @override
  Widget build(BuildContext context) {
    if (conversa == null || conversa?.horarioUltimaMensagem == null) {
      return const Text(" ");
    } else {
      return Text(DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
          conversa!.horarioUltimaMensagem!)));
    }
  }
}

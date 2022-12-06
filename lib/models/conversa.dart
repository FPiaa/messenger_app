import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:messenger_app/constants/firebase_realtime_constant.dart';
import 'package:messenger_app/models/mensagem.dart';
part "conversa.g.dart";

@JsonSerializable()
class Conversa {
  List<String> participantesIds;
  List<Mensagem>? mensagens;
  String id;
  @JsonKey(name: DatabaseConstants.lastMessageTime)
  int? horarioUltimaMensagem;
  @JsonKey(name: DatabaseConstants.lastMessageContent)
  String? conteudoUltimaMensagem;
  //Adm só é necessário para grupos

  Conversa(
      {required this.participantesIds,
      this.mensagens,
      required this.id,
      this.horarioUltimaMensagem,
      this.conteudoUltimaMensagem});

  addMessage(Mensagem message) {
    if (mensagens != null) {
      mensagens!.add(message);
    }
  }

  String destinatarioId(String usuarioAtivo) {
    return participantesIds.firstWhere((element) => element != usuarioAtivo);
  }

  factory Conversa.fromJson(Map<dynamic, dynamic> json) =>
      _$ConversaFromJson(json);
  Map<dynamic, dynamic> toJson() => _$ConversaToJson(this);

  @override
  bool operator ==(other) => other is Conversa && other.id == id;

  @override
  int get hashCode => sha1.convert(const Utf8Codec().encode(id)).hashCode;
}

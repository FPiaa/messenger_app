import 'package:json_annotation/json_annotation.dart';

part "mensagem.g.dart";

class MessageType {
  static const text = 0;
  static const image = 1;
}

@JsonSerializable()
class Mensagem {
  final String? content;
  final String remetente;
  final String? imageUrl;
  final int type;
  final int dataEnvio;
  String? id;

  Mensagem(
      {required this.remetente,
      required this.content,
      this.imageUrl,
      required this.dataEnvio,
      required this.type,
      this.id});

  factory Mensagem.fromJson(Map<dynamic, dynamic> json) =>
      _$MensagemFromJson(json);
  Map<dynamic, dynamic> toJson() => _$MensagemToJson(this);

  bool operator ==(other) => other is Mensagem && other.id == id;
}

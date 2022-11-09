import 'package:json_annotation/json_annotation.dart';
import 'package:messenger_app/models/pessoa.dart';

part "mensagem.g.dart";

@JsonSerializable()
class Mensagem {
  final String content;
  final String remetente;
  final String? imageUrl;
  final int dataEnvio;
  String? id;

  Mensagem(
      {required this.remetente,
      required this.content,
      this.imageUrl,
      required this.dataEnvio,
      this.id});

  factory Mensagem.fromJson(Map<dynamic, dynamic> json) =>
      _$MensagemFromJson(json);
  Map<dynamic, dynamic> toJson() => _$MensagemToJson(this);

  bool operator ==(other) => other is Mensagem && other.id == id;
}

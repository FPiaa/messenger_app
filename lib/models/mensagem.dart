import 'package:json_annotation/json_annotation.dart';
import 'package:messenger_app/models/pessoa.dart';

part "mensagem.g.dart";

@JsonSerializable()
class Mensagem {
  final String content;
  final Pessoa remetente;
  final String? imageUrl;
  late final int dataEnvio;

  Mensagem({
    required this.remetente,
    required this.content,
    this.imageUrl,
  }) {
    dataEnvio = DateTime.now().millisecondsSinceEpoch;
  }

  factory Mensagem.fromJson(Map<dynamic, dynamic> json) =>
      _$MensagemFromJson(json);
  Map<dynamic, dynamic> toJson() => _$MensagemToJson(this);
}

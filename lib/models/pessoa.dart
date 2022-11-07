import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part "pessoa.g.dart";

@JsonSerializable()
class Pessoa {
  final String username;
  final String email;
  final DateTime dataNascimento;
  String? photo;
  String? descricao;
  @JsonKey(required: true)
  final String id;

  Pessoa({
    required this.username,
    required this.email,
    required this.dataNascimento,
    required this.id,
    this.photo,
    this.descricao,
  });
  factory Pessoa.fromJson(Map<dynamic, dynamic> json) => _$PessoaFromJson(json);
  Map<String, dynamic> toJson() => _$PessoaToJson(this);
}

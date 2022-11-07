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
  late String id;

  Pessoa({
    required this.username,
    required this.email,
    required this.dataNascimento,
    String? id,
    this.photo,
    this.descricao,
  }) {
    if (id == null) {
      this.id = Uuid().v4();
    } else {
      this.id = id;
    }
  }

  factory Pessoa.fromJson(Map<String, dynamic> json) => _$PessoaFromJson(json);
  Map<String, dynamic> toJson() => _$PessoaToJson(this);
}

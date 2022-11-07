// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pessoa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pessoa _$PessoaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return Pessoa(
    username: json['username'] as String,
    email: json['email'] as String,
    dataNascimento: DateTime.parse(json['dataNascimento'] as String),
    id: json['id'] as String,
    photo: json['photo'] as String?,
    descricao: json['descricao'] as String?,
  );
}

Map<String, dynamic> _$PessoaToJson(Pessoa instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'dataNascimento': instance.dataNascimento.toIso8601String(),
      'photo': instance.photo,
      'descricao': instance.descricao,
      'id': instance.id,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mensagem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mensagem _$MensagemFromJson(Map<dynamic, dynamic> json) => Mensagem(
      remetente: Pessoa.fromJson(json['remetente'] as Map<String, dynamic>),
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
    )..dataEnvio = DateTime.parse(json['dataEnvio'] as String);

Map<String, dynamic> _$MensagemToJson(Mensagem instance) => <String, dynamic>{
      'content': instance.content,
      'remetente': instance.remetente,
      'imageUrl': instance.imageUrl,
      'dataEnvio': instance.dataEnvio.toIso8601String(),
    };

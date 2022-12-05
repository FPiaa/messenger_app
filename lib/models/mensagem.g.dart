// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mensagem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mensagem _$MensagemFromJson(Map<dynamic, dynamic> json) => Mensagem(
      remetente: json['remetente'] as String,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      dataEnvio: json['dataEnvio'] as int,
      type: json['type'] as int,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MensagemToJson(Mensagem instance) => <String, dynamic>{
      'content': instance.content,
      'remetente': instance.remetente,
      'imageUrl': instance.imageUrl,
      'dataEnvio': instance.dataEnvio,
      "type": instance.type,
      'id': instance.id,
    };

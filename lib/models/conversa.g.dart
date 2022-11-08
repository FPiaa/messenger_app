// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversa _$ConversaFromJson(Map<dynamic, dynamic> json) => Conversa(
      participantesIds: (json['participantes'] as List<String>),
      mensagens: (json['mensagens'] as List<dynamic>)
          .map((e) => Mensagem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$ConversaToJson(Conversa instance) => <String, dynamic>{
      'participantes': instance.participantesIds,
      'mensagens': instance.mensagens,
      'id': instance.id,
    };

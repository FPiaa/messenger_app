// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversa _$ConversaFromJson(Map<dynamic, dynamic> json) => Conversa(
      participantesIds: (json['participantesIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mensagens: (json['mensagens'] as List<dynamic>?)
          ?.map((e) => Mensagem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$ConversaToJson(Conversa instance) => <String, dynamic>{
      'participantesIds': instance.participantesIds,
      'mensagens': instance.mensagens,
      'id': instance.id,
    };

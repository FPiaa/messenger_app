import 'package:json_annotation/json_annotation.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';

//TODO: Fazer conversa virar classes abstrata e ter uma instanciação para grupo
// e para conversa ponto a ponto
part "conversa.g.dart";

@JsonSerializable()
class Conversa {
  List<String> participantesIds;
  List<Mensagem>? mensagens;
  String id;
  //Adm só é necessário para grupos

  Conversa({required this.participantesIds, this.mensagens, required this.id});

  //TODO: Error handling
  addMessage(Mensagem message) {
    if (mensagens != null) {
      mensagens!.add(message);
    }
  }

  factory Conversa.fromJson(Map<dynamic, dynamic> json) =>
      _$ConversaFromJson(json);
  Map<dynamic, dynamic> toJson() => _$ConversaToJson(this);
}

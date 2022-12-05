import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/models/pessoa.dart';

class ImageTile extends StatelessWidget {
  final Mensagem mensagem;
  final bool selecionada;
  const ImageTile({
    super.key,
    required this.mensagem,
    required this.selecionada,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = width * 0.5;
    return CachedNetworkImage(
      imageUrl: mensagem.imageUrl!,
      color: selecionada ? Colors.blue[50]!.withOpacity(0.3) : null,
      colorBlendMode: BlendMode.overlay,
      fit: BoxFit.scaleDown,
      height: size,
      width: size,
      filterQuality: FilterQuality.medium,
      progressIndicatorBuilder: (context, url, progress) =>
          CircularProgressIndicator(
        value: progress.progress,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

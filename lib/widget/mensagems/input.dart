import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/models/conversa.dart';
import 'package:messenger_app/models/mensagem.dart';
import 'package:messenger_app/pages/preview_page.dart';
import 'package:messenger_app/provider/conversa_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:provider/provider.dart';

class Input extends StatefulWidget {
  final Conversa conversa;
  final ScrollController scrollController;
  const Input(
      {super.key, required this.conversa, required this.scrollController});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool sendingImage = false;
  late ConversaProvider conversaProvider;
  late UsuarioAtivoProvider usuarioAtivoProvider;

  TextEditingController conteudo = TextEditingController();

  Future getFromImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final File image = File(xfile.path);
      setState(() {
        uploadImage(image);
        sendingImage = true;
      });
    }
  }

  uploadImage(File image) async {
    final String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    UploadTask upload =
        conversaProvider.uploadImage(image: image, name: fileName);
    try {
      TaskSnapshot task = await upload;
      final String imageUrl = await task.ref.getDownloadURL();
      setState(() {
        sendingImage = false;
        final Mensagem m =
            createMensagem(imageUrl: imageUrl, type: MessageType.image);
        onSendMessage(m);
      });
    } on FirebaseException catch (e) {
      setState(() {
        sendingImage = false;
      });
    }
  }

  onSendMessage(Mensagem mensagem) async {
    await conversaProvider.sendMessage(
        conversaId: widget.conversa.id, mensagem: mensagem);
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  showCameraPreview(File file) async {
    File? image = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewImagePage(file: file),
      ),
    );

    if (image != null) {
      uploadImage(image);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    conversaProvider = Provider.of<ConversaProvider>(context);
    usuarioAtivoProvider = context.read<UsuarioAtivoProvider>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ainda não tem acesso a câmera e arquivos"),
                  ),
                ),
              ),
            ),
            Form(
              child: Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: TextField(
                      maxLines: null,
                      controller: conteudo,
                      textInputAction: TextInputAction.send,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      onChanged: (_) {
                        var text = conteudo.text.trim();
                        if (text.length == 1 || text.isEmpty) setState(() {});
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        hintText: "Mensagem",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: conteudo.text.trim().isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        Mensagem mensagem = createMensagem(
                          conteudo: conteudo.text.trim(),
                          type: MessageType.text,
                        );
                        setState(() {
                          conteudo.clear();
                        });
                        onSendMessage(mensagem);
                      })
                  : IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CameraCamera(
                              onFile: (file) => showCameraPreview(file),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Mensagem createMensagem({
    String? conteudo,
    String? imageUrl,
    required int type,
  }) {
    return Mensagem(
        remetente: usuarioAtivoProvider.pessoa.id,
        content: conteudo,
        dataEnvio: DateTime.now().millisecondsSinceEpoch,
        type: type,
        imageUrl: imageUrl);
  }
}

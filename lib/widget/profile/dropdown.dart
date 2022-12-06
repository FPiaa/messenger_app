import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/preview_page.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ImageChoices extends StatefulWidget {
  final Pessoa pessoa;
  const ImageChoices({super.key, required this.pessoa});

  @override
  State<ImageChoices> createState() => _ImageChoicesState();
}

class _ImageChoicesState extends State<ImageChoices> {
  late ProfileProvider profileProvider;
  File? imagem;

  Future getFromImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final File image = File(xfile.path);
      setState(() {
        uploadImage(image);
      });
    }
  }

  uploadImage(File image) async {
    UploadTask upload =
        profileProvider.uploadImage(image: image, name: widget.pessoa.id);
    try {
      TaskSnapshot task = await upload;
      final String imageUrl = await task.ref.getDownloadURL();

      Pessoa p = widget.pessoa;
      p.photo = imageUrl;

      await profileProvider.updateProfile(p);
      setState(() {});
    } on FirebaseException catch (e) {
      setState(() {});
    }
  }

  showCameraPreview(BuildContext context, File file) async {
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
    final List<Widget> list = <Widget>[
      IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CameraCamera(
                  onFile: (file) => showCameraPreview(context, file),
                ),
              ),
            );
          },
          icon: const Icon(Icons.camera_alt)),
      IconButton(
        onPressed: () => getFromImagePicker(),
        icon: const Icon(Icons.image),
      ),
    ];
    profileProvider = Provider.of<ProfileProvider>(context);
    return DropdownButton<Widget>(
      value: null,
      icon: const Icon(Icons.image_search_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (Widget? value) {
        // This is called when the user selects an item.
        setState(() {});
      },
      items: list.map<DropdownMenuItem<Widget>>((Widget value) {
        return DropdownMenuItem<Widget>(
          value: value,
          child: value,
        );
      }).toList(),
    );
  }
}

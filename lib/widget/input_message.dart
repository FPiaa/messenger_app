import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    required this.formKey,
    required this.conteudo,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController conteudo;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  onSendMessage() {
    print(widget.conteudo.text);
    widget.conteudo.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ainda não tem acesso a camêra e arquivos"),
                  ),
                ),
              ),
            ),
            Form(
              key: widget.formKey,
              child: Flexible(
                child: TextFormField(
                  controller: widget.conteudo,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  onChanged: (_) {
                    var text = widget.conteudo.text.trim();
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: widget.conteudo.text.trim().isNotEmpty
                    ? onSendMessage
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

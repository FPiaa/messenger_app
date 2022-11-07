import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.pessoa, required this.isCurrentUser});
  final Pessoa pessoa;
  final bool isCurrentUser;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descricaoController;

  @override
  Widget build(BuildContext context) {
    double radius = widget.pessoa.photo != null ? 200 : 100;
    descricaoController = TextEditingController(text: widget.pessoa.descricao);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: buildProfile(radius),
    );
  }

  Widget buildProfile(double radius) {
    radius = (widget.pessoa.photo != null && widget.pessoa.photo!.isNotEmpty)
        ? radius
        : radius * 0.8;
    if (widget.isCurrentUser) {
      return SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: radius,
                  width: radius,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: radius / 2,
                        backgroundColor: Colors.transparent,
                        // foregroundImage: NetworkImage('https://via.placeholder.com/150'),
                        child: ClipOval(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: widget.pessoa.photo != null &&
                                  widget.pessoa.photo!.isNotEmpty
                              ? Image.asset(widget.pessoa.photo!)
                              : const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Ink(
                          width: 36,
                          height: 36,
                          child: InkWell(
                            splashColor: Colors.amber[100],
                            splashFactory: InkRipple.splashFactory,
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            onTap: () => print("Atualizar foto"),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SelectableText(widget.pessoa.username,
                style: const TextStyle(fontSize: 20)),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SelectableText(
                  "${AgeCalculator.age(widget.pessoa.dataNascimento).years} Anos",
                  style: const TextStyle(fontSize: 20))),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SelectableText(widget.pessoa.email,
                  style: const TextStyle(fontSize: 20))),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Ink(
              child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: descricaoController,
                  decoration: InputDecoration(
                    label: const Text("Descrição"),
                    border: const UnderlineInputBorder(),
                    icon: const Icon(Icons.description),
                    suffixIcon: InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        splashColor: Colors.amber[100],
                        splashFactory: InkRipple.splashFactory,
                        onTap: () => print("atualziar descrição"),
                        child: const Icon(Icons.update)),
                  )),
            ),
          )
        ]),
      ));
    } else {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: CircleAvatar(
                    radius: radius / 2,
                    backgroundColor: Colors.transparent,
                    // foregroundImage: NetworkImage('https://via.placeholder.com/150'),
                    child: SizedBox(
                      width: radius,
                      height: radius,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: widget.pessoa.photo != null &&
                                widget.pessoa.photo!.isNotEmpty
                            ? Image.asset(widget.pessoa.photo!)
                            : const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SelectableText(widget.pessoa.username,
                  style: const TextStyle(fontSize: 20)),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(
                    "${AgeCalculator.age(widget.pessoa.dataNascimento).years} Anos",
                    style: const TextStyle(fontSize: 20))),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(widget.pessoa.email,
                    style: const TextStyle(fontSize: 20))),
            widget.pessoa.descricao != null
                ? Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(widget.pessoa.descricao!),
                  )
                : const SizedBox.shrink()
          ],
        ),
      );
    }
  }
}

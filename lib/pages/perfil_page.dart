import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.pessoa, required this.isCurrentUser});
  final Pessoa pessoa;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    double radius = pessoa.photo != null ? 200 : 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Container(
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
                        child: pessoa.photo != null
                            ? Image.asset(pessoa.photo!)
                            : const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                ),
                isCurrentUser
                    ? Ink(
                        width: 50,
                        height: 50,
                        child: InkWell(
                          splashColor: Colors.amber[100],
                          splashFactory: InkRipple.splashFactory,
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          onTap: () {},
                          child: const Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SelectableText(pessoa.username,
                  style: const TextStyle(fontSize: 20)),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(
                    "${AgeCalculator.age(pessoa.dataNascimento).years} Anos",
                    style: const TextStyle(fontSize: 20))),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(pessoa.email,
                    style: const TextStyle(fontSize: 20))),
            pessoa.descricao != null
                ? Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(pessoa.descricao!),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

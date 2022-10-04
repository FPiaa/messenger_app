import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.pessoa, required this.isCurrentUser});
  final Pessoa pessoa;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    double radius = 200;
    return Scaffold(
      appBar: AppBar(
        title: Text(pessoa.username),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 56),
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
            Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                    "${AgeCalculator.age(pessoa.dataNascimento).years} Anos")),
            Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(pessoa.email)),
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

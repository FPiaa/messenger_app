import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';

class ReadOnlyProfile extends StatelessWidget {
  const ReadOnlyProfile({super.key, required this.pessoa});
  final Pessoa pessoa;

  @override
  Widget build(BuildContext context) {
    double radius = pessoa.photo != null ? 200 : 100;
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  width: radius,
                  height: radius,
                  child: ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: pessoa.photo != null && pessoa.photo!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: pessoa.photo!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Username",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SelectableText(
                    pessoa.username,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Idade",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SelectableText(
                    "${AgeCalculator.age(pessoa.dataNascimento).years} Anos",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SelectableText(
                    pessoa.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Descrição",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SelectableText(
                    pessoa.descricao != null ? "${pessoa.descricao}" : "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

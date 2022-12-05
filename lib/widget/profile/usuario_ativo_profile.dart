import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/pages/perfil_page.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ActiveUserProfile extends StatefulWidget {
  final Pessoa pessoa;
  const ActiveUserProfile({super.key, required this.pessoa});

  @override
  State<ActiveUserProfile> createState() => _ActiveUserProfileState();
}

class _ActiveUserProfileState extends State<ActiveUserProfile> {
  late TextEditingController descricaoController;
  late ProfileProvider profileProvider;
  final _formKey = GlobalKey<FormState>();
  DescriptionStatus _descriptionStatus = DescriptionStatus.reading;

  @override
  Widget build(BuildContext context) {
    double radius = widget.pessoa.photo != null ? 200 : 100;
    profileProvider = Provider.of<ProfileProvider>(context);
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
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: widget.pessoa.photo != null &&
                                widget.pessoa.photo!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.pessoa.photo!,
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
        ListTile(
          leading: const Icon(Icons.person),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Username",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(
                  widget.pessoa.username,
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
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(
                  "${AgeCalculator.age(widget.pessoa.dataNascimento).years} Anos",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              )
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SelectableText(
                  widget.pessoa.email,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              )
            ],
          ),
        ),
        if (_descriptionStatus == DescriptionStatus.editing)
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
                  suffixIcon: SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Ink(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            splashColor: Colors.amber[100],
                            splashFactory: InkRipple.splashFactory,
                            onTap: () =>
                                updateDescription(descricaoController.text),
                            child: const Icon(Icons.check),
                          ),
                        ),
                        Ink(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            splashColor: Colors.amber[100],
                            splashFactory: InkRipple.splashFactory,
                            onTap: () => setState(() {
                              _descriptionStatus = DescriptionStatus.reading;
                            }),
                            child: const Icon(Icons.cancel),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        else
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
                    "${widget.pessoa.descricao}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                )
              ],
            ),
            trailing: _descriptionStatus == DescriptionStatus.reading
                ? Ink(
                    child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    splashColor: Colors.amber[100],
                    splashFactory: InkRipple.splashFactory,
                    onTap: () => setState(() {
                      _descriptionStatus = DescriptionStatus.editing;
                      descricaoController =
                          TextEditingController(text: widget.pessoa.descricao);
                    }),
                    child: const Icon(Icons.edit),
                  ))
                : const CircularProgressIndicator(),
          ),
      ]),
    ));
  }

  updateDescription(String descricao) async {
    setState(() {
      _descriptionStatus = DescriptionStatus.updating;
    });
    Pessoa pessoa = widget.pessoa;
    pessoa.setDescricao = descricao;
    await profileProvider.updateProfile(pessoa);
    setState(() {
      _descriptionStatus = DescriptionStatus.reading;
    });
  }
}

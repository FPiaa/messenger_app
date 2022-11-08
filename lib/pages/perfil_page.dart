import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/pessoa.dart';
import 'package:messenger_app/provider/profile_provider.dart';
import 'package:messenger_app/provider/usuario_ativo_provider.dart';
import 'package:provider/provider.dart';

enum DescriptionStatus {
  reading,
  editing,
  updating,
}

class Profile extends StatefulWidget {
  const Profile({super.key, required this.pessoa});
  final Pessoa pessoa;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descricaoController;
  late ProfileProvider profileProvider;
  late UsuarioAtivoProvider usuarioAtivoProvider;
  DescriptionStatus _descriptionStatus = DescriptionStatus.reading;
  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    usuarioAtivoProvider = Provider.of<UsuarioAtivoProvider>(context);

    double radius = widget.pessoa.photo != null ? 200 : 100;
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
    if (widget.pessoa.id.compareTo(usuarioAtivoProvider.pessoa.id) == 0) {
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
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
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
                        descricaoController = TextEditingController(
                            text: usuarioAtivoProvider.pessoa.descricao);
                      }),
                      child: const Icon(Icons.edit),
                    ))
                  : const CircularProgressIndicator(),
            ),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey),
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
                      widget.pessoa.email,
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
                      "${widget.pessoa.descricao}",
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

  updateDescription(String descricao) async {
    setState(() {
      _descriptionStatus = DescriptionStatus.updating;
    });
    Pessoa pessoa = usuarioAtivoProvider.pessoa;
    pessoa.setDescricao = descricao;
    await profileProvider.updateProfile(pessoa);
    setState(() {
      _descriptionStatus = DescriptionStatus.reading;
    });
  }
}

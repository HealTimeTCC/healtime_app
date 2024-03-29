import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:healtime/shared/dto/dto_encerrar_cuidador_paciente.dart';

import '../../../../../../../shared/decorations/fonts_google.dart';
import '../../../../../../../shared/models/model_pessoa.dart';

class ModelPatient extends StatelessWidget {
  const ModelPatient({Key? key, required this.person}) : super(key: key);

  final Pessoa person;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .07,
      margin: EdgeInsets.symmetric(
        horizontal: size.width * .05,
        vertical: size.height * .01,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(size.width * .02),
            topRight: Radius.circular(size.width * .02),
          ),
          color: Colors.white),
      child: Row(
        children: [
          Container(
            width: size.width * .02,
            decoration: BoxDecoration(
              color: const Color(0xff02CCC9),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(size.width * .02),
                topLeft: Radius.circular(size.width * .02),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * .02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    person.nomePessoa,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontGoogle.textNormaleGoogle(size: size * .85),
                  ),
                  Text(
                    person.sobreNomePessoa,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontGoogle.textNormalGreyGoogle(size: size * .6),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * .003, horizontal: size.width * .03),
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(size.width)),
            child: Text(
              UtilBrasilFields.obterCpf(person.cpfPessoa),
              style: FontGoogle.textNormaleGoogle(
                size: size * .6,
                colorText: const Color(0xff172331),
              ),
            ),
          ),
          // IconButton(
          //     onPressed: () async {
          //       print("tap");
          //       // EncerrarCuidadorPaciente cuidadorPaciente =
          //       //     EncerrarCuidadorPaciente(
          //       //         cuidadorId: cuidadorId, pacienteId: pacienteId);
          //     },
          //     icon: Icon(Icons.delete_sweep)),
        ],
      ),
    );
  }
}

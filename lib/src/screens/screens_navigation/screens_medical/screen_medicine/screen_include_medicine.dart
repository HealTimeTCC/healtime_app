import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healtime/shared/models/enuns/enum_status_medicacao.dart';
import 'package:healtime/shared/models/model_medicacao.dart';

import '../../../../../shared/decorations/fonts_google.dart';
import '../../../../../shared/decorations/screen_background.dart';
import '../../../../../shared/models/enuns/enum_type_screen_medical.dart';
import '../../../../../shared/models/model_type_medicine.dart';
import 'Widget/model_text_field.dart';
import 'logic/medicine.dart';

class IncludeMedication extends StatefulWidget {
  const IncludeMedication({
    Key? key,
    required this.typeOperation,
  }) : super(key: key);

  final TypeScreenMedical typeOperation;

  @override
  State<IncludeMedication> createState() => _IncludeMedicationState();
}

class _IncludeMedicationState extends State<IncludeMedication> {
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textComposedController = TextEditingController();
  final TextEditingController _textLaboratoryController =
      TextEditingController();

  @override
  void dispose() {
    _textNameController.dispose();
    _textComposedController.dispose();
    _textLaboratoryController.dispose();
    super.dispose();
  }

  final List<String> _optionsMedicineGeneric = [
    'Sim, este medicamento é genérico.',
    'Não, este medicamento não é genérico.'
  ];

  String _selectMedicineGeneric = 'N';
  int _selectMedicineType = 1;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPage(),
          Positioned(
            top: 0,
            right: 20,
            left: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * .06,
                  ),
                  if (widget.typeOperation == TypeScreenMedical.notHomePage)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: const Color(0xff18CDCA),
                          size: size.width * .08),
                    ),
                  SizedBox(width: size.width * .02),
                  Expanded(
                    child: Text(
                      'Adicionar medicamento',
                      textAlign: TextAlign.center,
                      style: FontGoogle.textTitleGoogle(size: size * .9),
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * .1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * .07),
                    Text(
                      'Nome*',
                      style: FontGoogle.textSubTitleGoogle(size: size * .85),
                    ),
                    ModelTextField(textFieldController: _textNameController),
                    Text(
                      'Composto ativo*',
                      style: FontGoogle.textSubTitleGoogle(size: size * .85),
                    ),
                    ModelTextField(
                        textFieldController: _textComposedController),
                    Text(
                      'Laboratorio*',
                      style: FontGoogle.textSubTitleGoogle(size: size * .85),
                    ),
                    ModelTextField(
                        textFieldController: _textLaboratoryController),
                    Text(
                      'Genérico*',
                      style: FontGoogle.textSubTitleGoogle(size: size * .85),
                    ),
                    SizedBox(height: size.height * .01),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * .02),
                        border: Border.all(
                          color: const Color(0xff333333),
                        ),
                      ),
                      child: DropdownButton(
                        value: _selectMedicineGeneric,
                        style: FontGoogle.textNormaleGoogle(size: size * .68),
                        isExpanded: true,
                        underline: Container(),
                        borderRadius: BorderRadius.circular(size.width * .02),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: _optionsMedicineGeneric
                            .map(
                              (e) => DropdownMenuItem(
                                value: (e == 'Sim, este medicamento é genérico.'
                                    ? 'S'
                                    : 'N'),
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectMedicineGeneric = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: size.height * .02),
                    Text(
                      'Tipo*',
                      style: FontGoogle.textSubTitleGoogle(size: size * .85),
                    ),
                    FutureBuilder(
                      future: LogicMedicine.getListMedicine(context: context),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            {
                              return Container();
                            }
                          default:
                            {
                              final List<TypeMedicine> listTypesMedicine =
                                  snapshot.data ?? [];

                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * .02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * .02),
                                  border: Border.all(
                                    color: const Color(0xff333333),
                                  ),
                                ),
                                child: DropdownButton(
                                  value: _selectMedicineType,
                                  isExpanded: true,
                                  menuMaxHeight: size.height * .5,
                                  style: FontGoogle.textNormaleGoogle(
                                    size: size * .68,
                                  ),
                                  underline: Container(),
                                  borderRadius:
                                      BorderRadius.circular(size.width * .02),
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded),
                                  items: listTypesMedicine
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: (e.typeMedicineId),
                                          child: Text(
                                            e.titleTypeMedicine,
                                            style: FontGoogle.textNormaleGoogle(
                                              size: size * .75,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _selectMedicineType = value!;
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                        }
                      },
                    ),
                    SizedBox(height: size.height * .04),
                    ElevatedButton(
                      onPressed: () async {
                        ModelMedicacao medicine = ModelMedicacao(
                          compostoAtivoMedicacao: _textComposedController.text,
                          generico: _selectMedicineGeneric,
                          laboratorioMedicacao: _textLaboratoryController.text,
                          nomeMedicacao: _textNameController.text,
                          statusMedicacaoId: StatusMedicacao.ativo,
                          tipoMedicacaoId: _selectMedicineType,
                        );

                        await LogicMedicine.includeMedicine(
                          context: context,
                          medicine: medicine,
                          typeOperation: widget.typeOperation,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xff333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Adicionar medicamento',
                        style: GoogleFonts.getFont('Poppins',
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

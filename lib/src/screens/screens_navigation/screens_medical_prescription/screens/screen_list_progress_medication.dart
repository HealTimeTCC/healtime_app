import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healtime/services/provider/provider_home_page.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../../services/provider/prescription_medical/provider_prescription_medic.dart';
import '../../../../../shared/decorations/fonts_google.dart';
import '../../../../../shared/decorations/screen_background.dart';
import '../logic_options/enum_type_state.dart';

class ListProgressMedication extends StatefulWidget {
  const ListProgressMedication({
    Key? key,
    required this.codPrescription,
    required this.codMedicine,
  }) : super(key: key);
  final int codPrescription;
  final int codMedicine;

  @override
  State<ListProgressMedication> createState() => _ListProgressMedicationState();
  static GlobalKey<ScaffoldMessengerState> progressMedicationKeyScaffold =
      GlobalKey<ScaffoldMessengerState>();
}

class _ListProgressMedicationState extends State<ListProgressMedication> {
  bool search = false;
  late ProviderHomePage providerHomePage;
  @override
  void dispose() {
    super.dispose();
    search = false;
  }
  @override
  Widget build(BuildContext context) {
    providerHomePage = Provider.of(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: ListProgressMedication.progressMedicationKeyScaffold,
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundPage(),
            Column(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: size.height * .08,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Color(0xff1AE8E4),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * .02),
                        Text(
                          'Andamento da medicação',
                          style: FontGoogle.textTitleGoogle(
                            size: size * .85,
                            fontWeightGoogle: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<ProviderPrescriptionMedical>(
                    builder: (context, value, child) {
                      if (!search) {
                        value.listProgressMedication(
                            context: context,
                            codPrescription: widget.codPrescription,
                            codMedicine: widget.codMedicine);
                        search = true;
                      }
                      switch (value.getTypeStateRequestPrescriptionMedicine) {
                        case TypeStateRequest.init:
                          return Container();
                        case TypeStateRequest.awaitCharge:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case TypeStateRequest.fail:
                          return ListView(
                            shrinkWrap: true,
                            children: [
                              Lottie.asset(
                                'assets/json/notfound.json',
                              ),
                              Text(
                                "Não foi possível obter o andamento da medicação.",
                                style:
                                    FontGoogle.textSubTitleGoogle(size: size),
                              ),
                            ],
                          );
                        case TypeStateRequest.success:

                          if (value.getMedicationProgressDto.isEmpty) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Lottie.asset(
                                  'assets/json/notfound.json',
                                ),
                                Text(
                                  "Por aqui está tudo certo!",
                                  style:
                                      FontGoogle.textSubTitleGoogle(size: size),
                                ),
                              ],
                            );
                          }else{
                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8, right: 8),
                                          child: Text("Total: ${value.getMedicationProgressDto.length} doses", style:  FontGoogle.textSubTitleGoogle(size: size * .8),),
                                        ),
                                    ),
                                     Expanded(
                                      child: ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                        itemCount: value.getMedicationProgressDto.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Slidable(
                                              endActionPane: ActionPane(
                                                  motion: const ScrollMotion(),
                                                  children: [
                                                    SlidableAction(
                                                        onPressed: (context) async{
                                                          if(!value.getMedicationProgressDto[index].baixaAndamentoMedicacao){
                                                            await value.BaixaAndamentoMedicacao(
                                                                codAndamentoMedicacao: value.getMedicationProgressDto[index].andamentoMedicacaoId,
                                                                codAplicador: providerHomePage.getDataPerson?.pessoaId ?? 0,
                                                                context: context);
                                                            if(context.mounted){
                                                              await value.listProgressMedication(
                                                                  context: context,
                                                                  codPrescription: widget.codPrescription,
                                                                  codMedicine: widget.codMedicine);
                                                            }
                                                          }
                                                          else{
                                                            ListProgressMedication.progressMedicationKeyScaffold.currentState?.showSnackBar(
                                                              const SnackBar(content:
                                                              Text("Andamento já finalizado"),
                                                                  duration: Duration(seconds: 5),
                                                                  closeIconColor: Colors.white,
                                                                backgroundColor: Colors.green,
                                                              )
                                                            );
                                                          
                                                          }
                                                        },
                                                        icon: value.getMedicationProgressDto[index].baixaAndamentoMedicacao ? Icons.warning_amber_outlined : Icons.check_outlined,
                                                        backgroundColor: value.getMedicationProgressDto[index].baixaAndamentoMedicacao ? Colors.red : Colors.green,
                                                        label: value.getMedicationProgressDto[index].baixaAndamentoMedicacao ? "Finalizado" : "Baixa",
                                                        spacing: size.width * .05,
                                                      borderRadius:  BorderRadius.circular(size.height * .02)
                                                    ),
                                                  ],
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: size.height * .22,
                                                  width: size.width * .9,
                                                  padding: EdgeInsets.all(size.height * .01),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 1,
                                                          offset: Offset(1, 2),
                                                        )
                                                      ],
                                                      borderRadius: BorderRadius.circular(size.height * .02)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                              "Cód. Medicação: ",
                                                              style: FontGoogle.textSubTitleGoogle(
                                                                fontWeightText: FontWeight.w700,
                                                                size: size * .85,
                                                              ),
                                                            ),
                                                              Text(
                                                                "${value.getMedicationProgressDto[index].medicacaoId}",
                                                                style: FontGoogle.textSubTitleGoogle(
                                                                  size: size * .85,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                          padding: EdgeInsets.symmetric(horizontal: size.width * .01),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(size.width * .01),
                                                              color: value.getMedicationProgressDto[index].baixaAndamentoMedicacao ?
                                                                   Colors.red :Colors.green ,
                                                            ),
                                                            child: Text(value.getMedicationProgressDto[index].baixaAndamentoMedicacao ? "Fechada" : "Pendente",
                                                              style: FontGoogle.textSubTitleGoogle(
                                                              size: size * .7,
                                                                colorText: Colors.white
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Aplicação em: ",
                                                            style: FontGoogle.textSubTitleGoogle(
                                                            fontWeightText: FontWeight.w700,
                                                            size: size * .85,
                                                            ),
                                                          ),
                                                          Text(DateFormat("dd/MM/yyyy hh:mm").format(value.getMedicationProgressDto[index].mtAndamentoMedicacao,),
                                                            style: FontGoogle.textSubTitleGoogle(
                                                            size: size * .85,
                                                          ),)
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Quantidade: ",
                                                            style: FontGoogle.textSubTitleGoogle(
                                                            fontWeightText: FontWeight.w700,
                                                            size: size * .85,
                                                            ),
                                                          ),
                                                          Text("${value.getMedicationProgressDto[index].qtdeMedicao} UN",
                                                            style: FontGoogle.textSubTitleGoogle(
                                                            size: size * .85,
                                                          ),)
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text("Cód: ${value.getMedicationProgressDto[index].andamentoMedicacaoId}"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if(value.getTypeStateRequestLowProgressError == TypeStateRequest.awaitCharge) ...[
                                  Container(
                                    height: size.height,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.5),

                                    ),
                                    child: const Center(child: CircularProgressIndicator()),
                                  ),
                                ]
                              ],
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:healtime/services/data_locale/data_preferences.dart';
import 'package:healtime/shared/consts/consts_key_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:healtime/shared/dto/dto_pessoa_auth.dart';
import 'package:healtime/shared/models/model_pessoa.dart';

import '../../shared/consts/consts_required.dart';
import '../../shared/dto/dto_pessoa_register.dart';

class ApiPessoa {
  /* Autenticar usuário */
  static Future<Map<String, dynamic>> authUser(
      {required DtoPessoa pessoa}) async {
    int statusCode = 400;

    Uri uriApi = Uri.parse('${ConstsRequired.urlBaseApi}Pessoa/Autenticar');

    http.Response response = await http.post(uriApi,
        body: json.encode(pessoa),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      statusCode = response.statusCode;

      /* Pegar os dados que chegam e converte para o objeto Pessoa*/
      Pessoa pessoaData = Pessoa.fromJson(jsonDecode(response.body));

      /* Adicionar a senha do usuario para salvar todos os dados do usuario de uma vez */
      pessoaData.passwordString = pessoa.passwordString;
      String dataUser = jsonEncode(pessoaData);

      DataPreferences.savedDataString(dataUser, ConstsPreferences.keyUser);
    }

    Map<String, dynamic> responseApi = {
      'statusCode': statusCode,
      'response': response.body,
    };

    return responseApi;
  }

  /* Registrar usuário */
  static Future<int> registerUser({required DtoPessoaRegister pessoa}) async {
    try {
      Uri uriApi = Uri.parse('${ConstsRequired.urlBaseApi}Pessoa/Registro');

      http.Response response = await http.post(uriApi,
          body: jsonEncode(pessoa),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        DtoPessoa dtoPessoa = DtoPessoa(
            emailContato: pessoa.contatoEmail,
            passwordString: pessoa.passwordString);

        await authUser(pessoa: dtoPessoa);

        return 200;
      } else {
        return response.statusCode;
      }
    } on TimeoutException catch (_) {
      return 501;
    } catch (e) {
      print(e);
      return 400;
    }
  }
}

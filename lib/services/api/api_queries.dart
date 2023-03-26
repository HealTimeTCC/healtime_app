import 'dart:convert';

import '../../shared/dto/dto_query.dart';
import 'package:http/http.dart' as http;

class ApiQueries {
  static Future<Map<String, dynamic>> postQuery({required DtoQuery query}) async{
    Uri uriApi = Uri.parse('http://www.healtime.somee.com/healtime/ConsultaMedica/AgendarConsulta');

    http.Response response = await http.post(uriApi,
        body: jsonEncode(query), headers: {'Content-Type': 'application/json'});

    return {
      'statusCode': response.statusCode,
      'body': response.body
    };
  }
}
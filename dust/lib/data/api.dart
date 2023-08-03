import 'dart:convert';

import 'package:dust/data/mise.dart';
import 'package:http/http.dart' as http;

class MiseApi {
  final BASE_URL = "apis.data.go.kr";
  final String key =
      "j3o8Td8SRZ5AwIVClRupxZESjVop3bPE9e6OiE0UPJifD/8mV4AzLV6pzeKw7KBXDOpsy1weRkoVrf9ae+mqcw==";

  Future<List<Mise>> getMiseData(String stationName) async {
    var url = Uri.https(
      BASE_URL,
      "/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty",
      {
        'serviceKey': key,
        "returnType": "json",
        "numOfRows": "100",
        "pageNo": "1",
        "stationName": stationName,
        "dataTerm": "DAILY",
        "ver": "1.0",
      },
    );

    final response = await http.get(url);
    List<Mise> data = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String, dynamic>;

      for (final _res in res["response"]["body"]["items"]) {
        final m = Mise.fromJson(_res as Map<String, dynamic>);
        data.add(m);
      }

      return data;
    } else {
      return [];
    }
  }
}

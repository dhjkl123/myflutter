import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:cloth/data/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  final BASE_URL = "apis.data.go.kr";
  final PATH = "1360000/VilageFcstInfoService_2.0/getVilageFcst";
  final SERVIC_KEY =
      "j3o8Td8SRZ5AwIVClRupxZESjVop3bPE9e6OiE0UPJifD/8mV4AzLV6pzeKw7KBXDOpsy1weRkoVrf9ae+mqcw==";

  Future<List<Weather>> getWeather(
      int x, int y, int date, String base_time) async {
    Uri uri = Uri.http(
      BASE_URL,
      PATH,
      {
        "serviceKey": SERVIC_KEY,
        "pageNo": "1",
        "numOfRows": "1000",
        "dataType": "JSON",
        "base_date": date.toString(),
        "base_time": base_time,
        "nx": x.toString(),
        "ny": y.toString()
      },
    );
    var respose = await http.get(uri);

    List<Weather> weathers = [];

    if (respose.statusCode == 200) {
      String body = utf8.decode(respose.bodyBytes);
      var res = json.decode(body) as Map<String, dynamic>;
      List<dynamic> _data = [];
      _data = res["response"]["body"]["items"]["item"] as List<dynamic>;
      final data = groupBy(_data, (o) => "${o["fcstTime"]}").entries.toList();

      for (var _r in data) {
        var tmp = {"fcstTime": _r.key, "fcstDate": _r.value.first["fcstDate"]};

        for (var _d in _r.value) {
          tmp[_d["category"]] = _d["fcstValue"];
        }

        var w = Weather.fromJson(tmp);
        weathers.add(w);
      }
    }
    return weathers;
  }
}

import 'package:cloth/data/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  Future<List<ClothTmp>> getTmp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> tmp30 = preferences.getStringList("30") ??
        [
          "assets/img/shirts.png",
          "assets/img/jumper.png",
          "assets/img/pants.png"
        ];

    List<String> tmp20 = preferences.getStringList("20") ??
        [
          "assets/img/shirts.png",
          "assets/img/jumper.png",
          "assets/img/pants.png"
        ];

    List<String> tmp10 = preferences.getStringList("10") ??
        [
          "assets/img/shirts.png",
          "assets/img/jumper.png",
          "assets/img/pants.png"
        ];

    List<String> tmp0 = preferences.getStringList("0") ??
        [
          "assets/img/shirts.png",
          "assets/img/jumper.png",
          "assets/img/pants.png"
        ];

    return [
      ClothTmp(tmp: 30, cloth: tmp30),
      ClothTmp(tmp: 20, cloth: tmp20),
      ClothTmp(tmp: 10, cloth: tmp10),
      ClothTmp(tmp: 0, cloth: tmp0),
    ];
  }

  Future<void> setTmp(ClothTmp clothTmp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setStringList("${clothTmp.tmp}", clothTmp.cloth);
  }
}

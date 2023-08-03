class Weather {
  final String date;
  final int time;
  final int pop;
  final int pty;
  final String pcp;
  final int sky;
  final double wsd;
  final int tmp;
  final int reh;

  Weather({
    required this.date,
    required this.time,
    required this.pop,
    required this.pty,
    required this.pcp,
    required this.sky,
    required this.wsd,
    required this.tmp,
    required this.reh,
  });

  factory Weather.fromJson(Map<String, dynamic> data) {
    return Weather(
      date: data["fcstDate"],
      time: int.tryParse(data["fcstTime"] ?? "") ?? 0,
      pop: int.tryParse(data["POP"] ?? "") ?? 0,
      pty: int.tryParse(data["PTY"] ?? "") ?? 0,
      sky: int.tryParse(data["SKY"] ?? "") ?? 0,
      wsd: double.tryParse(data["WSD"] ?? "") ?? 0,
      tmp: int.tryParse(data["TMP"] ?? "") ?? 0,
      reh: int.tryParse(data["REH"] ?? "") ?? 0,
      pcp: data["PCP"] ?? "",
    );
  }
}

class LocationData {
  final String name;
  final int x;
  final int y;
  final double lat;
  final double lng;

  LocationData(this.name, this.x, this.y, this.lat, this.lng);
}

class ClothTmp {
  final int tmp;
  List<String> cloth;

  ClothTmp({required this.tmp, required this.cloth});
}

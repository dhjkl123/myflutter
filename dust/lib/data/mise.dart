class Mise {
  int pm10;
  int pm25;
  int khai;
  String dataTime;
  // double so;
  // double co;
  // double no;
  // double o3;

  Mise(
      {required this.pm10,
      required this.pm25,
      required this.khai,
      required this.dataTime});

  factory Mise.fromJson(Map<String, dynamic> data) {
    return Mise(
        pm10: int.tryParse(data["pm10Value"] ?? "") ?? 0,
        pm25: int.tryParse(data["pm25Value"] ?? "") ?? 0,
        khai: int.tryParse(data["khaiValue"] ?? "") ?? 0,
        dataTime: data["dataTime"] ?? "");
  }
}

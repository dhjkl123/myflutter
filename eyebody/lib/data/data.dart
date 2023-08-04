import 'dart:ui';

class Food {
  int? id;
  int date;
  int type;
  int kcal;
  String image;
  dynamic memo;

  Food({
    this.id,
    required this.date,
    required this.type,
    required this.kcal,
    required this.image,
    required this.memo,
  });

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      id: data["id"],
      date: data["date"],
      type: data["type"],
      kcal: data["kcal"],
      image: data["image"],
      memo: data["memo"] == int ? data["memo"].toString() : data["memo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "type": type,
      "kcal": kcal,
      "image": image,
      "memo": memo,
    };
  }
}

class WorkOut {
  int? id;
  int date;
  int time;
  String image;
  String name;
  String memo;

  WorkOut({
    this.id,
    required this.date,
    required this.image,
    required this.name,
    required this.memo,
    required this.time,
  });

  factory WorkOut.fromDB(Map<String, dynamic> data) {
    return WorkOut(
        id: data["id"],
        date: data["date"],
        name: data["name"],
        image: data["image"],
        memo: data["memo"],
        time: data["time"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "name": name,
      "image": image,
      "memo": memo,
      "time": time,
    };
  }
}

class EyeBody {
  int? id;
  int date;
  int weight;
  String image;

  EyeBody({
    this.id,
    required this.date,
    required this.weight,
    required this.image,
  });

  factory EyeBody.fromDB(Map<String, dynamic> data) {
    return EyeBody(
      id: data["id"],
      date: data["date"],
      weight: data["weight"],
      image: data["image"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "weight": weight,
      "image": image,
    };
  }
}

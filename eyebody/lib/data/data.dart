class Food {
  int id;
  int date;
  int type;
  int kcal;
  String image;
  String memo;

  Food({
    required this.id,
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
      memo: data["memo"],
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
  final int id;
  final int date;
  final int type;
  final String image;
  final String name;
  final String memo;

  WorkOut({
    required this.id,
    required this.date,
    required this.type,
    required this.image,
    required this.name,
    required this.memo,
  });

  factory WorkOut.fromDB(Map<String, dynamic> data) {
    return WorkOut(
      id: data["id"],
      date: data["date"],
      type: data["type"],
      name: data["name"],
      image: data["image"],
      memo: data["memo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "type": type,
      "name": name,
      "image": image,
      "memo": memo,
    };
  }
}

class EyeBody {
  final int id;
  final int date;
  final int weight;
  final String image;

  EyeBody({
    required this.id,
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

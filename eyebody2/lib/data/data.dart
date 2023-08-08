abstract class MyData {
  int? id;
  int? date;

  MyData({
    this.id,
    this.date,
  });

  MyData fromDB(Map<String, dynamic> data);
  Map<String, dynamic> toMap();
}

class Food extends MyData {
  int? type;
  int? kcal;
  int? time;
  int? meal;

  String? memo;
  String? image;

  Food({
    super.id,
    super.date,
    this.image,
    this.kcal,
    this.memo,
    this.time,
    this.type,
    this.meal,
  });

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      date: data["date"],
      image: data["image"],
      kcal: data["kcal"],
      memo: data["memo"],
      time: data["time"],
      type: data["type"],
      meal: data["meal"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "image": image,
      "kcal": kcal,
      "memo": memo,
      "time": time,
      "type": type,
      "meal": meal,
    };
  }

  @override
  Food fromDB(Map<String, dynamic> data) {
    return Food.fromDB(data);
  }
}

class Workout extends MyData {
  int? intense;
  int? calorie;
  int? time;
  int? part;
  int? type;
  int? distance;

  String? memo;
  String? name;

  Workout({
    super.date,
    super.id,
    this.calorie,
    this.memo,
    this.time,
    this.part,
    this.intense,
    this.name,
    this.type,
    this.distance,
  });

  factory Workout.fromDB(Map<String, dynamic> data) {
    return Workout(
        date: data["date"],
        id: data["id"],
        calorie: data["calorie"],
        memo: data["memo"],
        time: data["time"],
        intense: data["intense"],
        part: data["part"],
        name: data["name"],
        type: data["type"],
        distance: data["distance"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "calorie": calorie,
      "memo": memo,
      "time": time,
      "intense": intense,
      "part": part,
      "name": name,
      "type": type,
    };
  }

  @override
  Workout fromDB(Map<String, dynamic> data) {
    return Workout.fromDB(data);
  }
}

class Eyebody extends MyData {
  String? memo;
  String? image;

  Eyebody({
    super.date,
    super.id,
    this.image,
    this.memo,
  });

  factory Eyebody.fromDB(Map<String, dynamic> data) {
    return Eyebody(
      date: data["date"],
      id: data["id"],
      image: data["image"],
      memo: data["memo"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "image": image,
      "memo": memo,
    };
  }

  @override
  MyData fromDB(Map<String, dynamic> data) {
    return Eyebody.fromDB(data);
  }
}

class Weight {
  int? id;
  int? date;

  int? fat;
  int? muscle;

  Weight({
    this.date,
    this.id,
    this.fat,
    this.muscle,
  });

  factory Weight.fromDB(Map<String, dynamic> data) {
    return Weight(
      date: data["date"],
      id: data["id"],
      fat: data["fat"],
      muscle: data["muscle"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "fat": fat,
      "muscle": muscle,
    };
  }
}

class Diary {
  String title;
  String memo;
  String category;

  int date;
  late int? id;
  int status;
  String image;

  Diary({
    required this.title,
    required this.memo,
    required this.category,
    required this.date,
    required this.status,
    required this.image,
    this.id,
  });
}

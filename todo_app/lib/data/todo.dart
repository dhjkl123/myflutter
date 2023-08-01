class Todo {
  String title;
  String memo;
  String category;
  int color;
  int? done = 0;
  int date;
  late int? id;

  Todo({
    required this.title,
    required this.memo,
    required this.category,
    required this.color,
    this.done,
    required this.date,
    this.id,
  });
}

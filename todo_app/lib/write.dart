import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/todo.dart';

class TodoWritePage extends StatefulWidget {
  const TodoWritePage({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoWritePage> createState() => _TodoWritePageState();
}

class _TodoWritePageState extends State<TodoWritePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  int colorindex = 0;
  int categoryindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                widget.todo.title = nameController.text;
                widget.todo.memo = memoController.text;
                await databaseHelper.insertTodo(widget.todo);
                Navigator.of(context).pop(widget.todo);
              },
              child: Text(
                "저장",
                style: TextStyle(
                  color: Colors.black,
                ),
              ))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: Text(
                "제목",
                style: TextStyle(fontSize: 20),
              ),
              margin: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            );
          } else if (idx == 1) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: TextField(
                controller: nameController,
              ),
            );
          } else if (idx == 2) {
            return InkWell(
              onTap: () {
                List<Color> colors = [
                  Color(0xFF80d3f4),
                  Color(0xffa794fa),
                  Color(0xfffb91d1),
                  Color(0xfffb8a94),
                  Color(0xfffebd9a),
                  Color(0xff51e29d),
                  Color(0xffffffff),
                ];

                widget.todo.color = colors[colorindex].value;
                colorindex++;

                setState(() {
                  colorindex = colorindex % colors.length;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "색상",
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: Color(widget.todo.color),
                      )
                    ]),
              ),
            );
          } else if (idx == 3) {
            return InkWell(
              onTap: () {
                List<String> category = ["공부", "운동", "게임"];
                widget.todo.category = category[categoryindex];

                categoryindex++;
                setState(() {
                  categoryindex = categoryindex % category.length;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "카테고리",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(widget.todo.category),
                  ],
                ),
              ),
            );
          } else if (idx == 4) {
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text(
                "메모",
                style: TextStyle(fontSize: 20),
              ),
            );
          } else if (idx == 5) {
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: TextField(
                controller: memoController,
                maxLines: 10,
                minLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            );
          }

          return SizedBox();
        },
        itemCount: 6,
      ),
    );
  }
}

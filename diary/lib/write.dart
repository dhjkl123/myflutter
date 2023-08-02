import 'package:diary/data/database.dart';
import 'package:diary/data/diary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DiaryWritePage extends StatefulWidget {
  const DiaryWritePage({super.key, required this.diary});

  final Diary diary;

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  int imgIndex = 0;

  List<String> imgs = [
    "asset/img/b1.jpg",
    "asset/img/b2.jpg",
    "asset/img/b3.jpg",
    "asset/img/b4.jpg",
  ];

  List<String> statusImg = [
    "asset/img/ico-weather_2.png",
    "asset/img/ico-weather_3.png",
    "asset/img/ico-weather.png",
  ];

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEditingController.text = widget.diary.title;
    memoEditingController.text = widget.diary.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              widget.diary.title = nameEditingController.text;
              widget.diary.memo = memoEditingController.text;
              await databaseHelper.insertDiary(widget.diary);
              Navigator.of(context).pop();
            },
            child: Text(
              "저장",
              style: TextStyle(
                color: Colors.black,
              ),
            ))
      ]),
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return InkWell(
                onTap: () {
                  setState(() {
                    widget.diary.image = imgs[imgIndex];
                    imgIndex++;
                    imgIndex = imgIndex % imgs.length;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    widget.diary.image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (idx == 1) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var s in statusImg)
                      InkWell(
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.all(6),
                          child: Image.asset(s),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color:
                                    statusImg.indexOf(s) == widget.diary.status
                                        ? Colors.blue
                                        : Colors.transparent,
                              )),
                        ),
                        onTap: () {
                          setState(() {
                            widget.diary.status = statusImg.indexOf(s);
                          });
                        },
                      )
                  ],
                ),
              );
            } else if (idx == 2) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  "제목",
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else if (idx == 3) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(controller: nameEditingController),
              );
            } else if (idx == 4) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text("내용"),
              );
            } else if (idx == 5) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: memoEditingController,
                  minLines: 10,
                  maxLines: 20,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                    color: Colors.black,
                  ))),
                ),
              );
            }

            return Container();
          }),
    );
  }
}

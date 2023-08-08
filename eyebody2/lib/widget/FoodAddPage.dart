import 'dart:io';

import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/data/database.dart';
import 'package:eyebody2/data/query.dart';
import 'package:eyebody2/style.dart';
import 'package:eyebody2/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodAddPage extends StatefulWidget {
  final Food food;

  const FoodAddPage({super.key, required this.food});

  @override
  State<FoodAddPage> createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  @override
  // TODO: implement widget
  Food get food => super.widget.food;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    memoController.text = food.memo!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 1.0,
          actions: [
            TextButton(
                onPressed: () {
                  final db = DatabaseHelper.instance;
                  Query query = Query(tableName: DatabaseHelper.foodTable);

                  food.memo = memoController.text;

                  query.insertDataById(food);
                  Navigator.of(context).pop();
                },
                child: Text("저장"))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0),
                child: InkWell(
                  child: AspectRatio(
                    child: food.image!.length == 0
                        ? Image.asset("assets/img/food.png")
                        : Image.file(File(food.image!)),
                    aspectRatio: 2,
                  ),
                  onTap: () {
                    selectImage();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("식사시간"),
                  InkWell(
                    child: Text(timetoString()),
                    onTap: () async {
                      TimeOfDay? _time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (_time != null) {
                        setState(() {
                          food.time = int.parse(
                              "${_time!.hour}${Utils.makeTwoDigit(_time.minute)}");
                        });
                      }
                    },
                  ),
                ],
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: mealTime.length,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                children: [
                  for (int i = 0; i < mealTime.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          food.type = i;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: food.type == i ? mainColor : iBgColor),
                          alignment: Alignment.center,
                          child: Text(
                            mealTime[i],
                            style: TextStyle(
                                color: food.type == i ? txtColor : iTxtColor),
                          )),
                    )
                ],
              ),
              Text(
                "식단 평가",
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                children: [
                  for (int j = 0; j < mealType.length; j++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          food.meal = j;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: food.meal == j ? mainColor : iBgColor),
                          alignment: Alignment.center,
                          child: Text(
                            mealType[j],
                            style: TextStyle(
                                color: food.meal == j ? txtColor : iTxtColor),
                          )),
                    )
                ],
              ),
              Text(
                "메모",
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: memoController,
                  maxLines: 10,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: txtColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String timetoString() {
    String _t = food.time.toString();

    String _m = _t.substring(_t.length - 2);
    String _h = _t.substring(0, _t.length - 2);

    TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
    return "${time.hour > 11 ? "오후" : "오전"}${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)}";
  }

  Future<void> selectImage() async {
    final _img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_img != null) {
      setState(() {
        food.image = _img.path;
      });
    }
  }
}

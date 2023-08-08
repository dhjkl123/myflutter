import 'dart:io';

import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/data/database.dart';
import 'package:eyebody2/data/query.dart';
import 'package:eyebody2/style.dart';
import 'package:eyebody2/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutAddPage extends StatefulWidget {
  final Workout workout;

  const WorkoutAddPage({super.key, required this.workout});

  @override
  State<WorkoutAddPage> createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  @override
  // TODO: implement widget
  Workout get workout => super.widget.workout;
  TextEditingController memoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController distController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    memoController.text = workout.memo!;
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

                  workout.memo = memoController.text;
                  workout.name = nameController.text;
                  workout.time = int.parse(timeController.text);
                  workout.calorie = int.parse(calController.text);
                  workout.distance = int.parse(distController.text);

                  query.insertDataById(workout);
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
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    InkWell(
                      child: Image.asset("assets/img/${workout.type}.png"),
                      onTap: () {
                        setState(() {
                          workout.type = (workout.type! + 1) % 4;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: txtColor, width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("운동시간"),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: txtColor, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("운동칼로리"),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: calController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: txtColor, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("운동거리"),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: distController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: txtColor, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("운동부위"),
                  InkWell(
                    child: Text(""), //Text(timetoString()),
                    onTap: () async {
                      TimeOfDay? _time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (_time != null) {
                        setState(() {
                          workout.time = int.parse(
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
                crossAxisCount: wPart.length,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                children: [
                  for (int i = 0; i < wPart.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          workout.part = i;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: workout.part == i ? mainColor : iBgColor),
                          alignment: Alignment.center,
                          child: Text(
                            wPart[i],
                            style: TextStyle(
                                color:
                                    workout.part == i ? txtColor : iTxtColor),
                          )),
                    )
                ],
              ),
              Text(
                "운동강도",
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                children: [
                  for (int j = 0; j < wIntense.length; j++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          workout.intense = j;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  workout.intense == j ? mainColor : iBgColor),
                          alignment: Alignment.center,
                          child: Text(
                            wIntense[j],
                            style: TextStyle(
                                color: workout.intense == j
                                    ? txtColor
                                    : iTxtColor),
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

  // String timetoString() {
  //   String _t = workout.time.toString();

  //   String _m = _t.substring(_t.length - 2);
  //   String _h = _t.substring(0, _t.length - 2);

  //   TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
  //   return "${time.hour > 11 ? "오후" : "오전"}${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)}";
  // }

  // Future<void> selectImage() async {
  //   final _img = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (_img != null) {
  //     setState(() {
  //       workout.image = _img.path;
  //     });
  //   }
  // }
}

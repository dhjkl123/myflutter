import 'dart:io';

import 'package:eyebody/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/databasehelper.dart';

class WorkoutAddPage extends StatefulWidget {
  const WorkoutAddPage({super.key, required this.workOut});

  final WorkOut workOut;

  @override
  State<WorkoutAddPage> createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  TextEditingController workoutController = TextEditingController();
  TextEditingController workoutTimeController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  WorkOut get workout => widget.workOut;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    workoutController.text = workout.name;
    workoutTimeController.text = workout.time.toString();
    memoController.text = workout.memo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              workout.memo = memoController.text;
              workout.name = workoutController.text;
              workout.time = int.parse(workoutTimeController.text);

              final dbhelper = DataBaseHelper.instance;
              await dbhelper.insertWorkOut(workout);
              Navigator.of(context).pop();
            },
            child: Text("저장"),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("어떤 운동을 하셨나요?"),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: workoutController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("운동시간"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: workoutTimeController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              selectImage();
            },
            child: SizedBox(
              width: 200,
              child: workout.image.isEmpty
                  ? AspectRatio(
                      child: Image.asset("assets/img/workout.png"),
                      aspectRatio: 1,
                    )
                  : AspectRatio(
                      child: Image.file(File(workout.image)),
                      aspectRatio: 1,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("메모"),
                TextField(
                  controller: memoController,
                  minLines: 10,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final XFile pickedFile =
          await _picker.pickImage(source: ImageSource.gallery) ??
              XFile(workout.image);
      setState(() {
        workout.image = pickedFile.path;
      });
    } catch (e) {
      print(e);
    }

    // final __img =
    //     await MultipleImagesPicker.pickImages(maxImages: 1, enableCamera: true);
    // if (__img.length < 1) return;

    // setState(() {
    //   food.image = __img.first.identifier!;
    // });
  }
}

import 'dart:io';

import 'package:eyebody/data/data.dart';
import 'package:eyebody/data/databasehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FoodAddPage extends StatefulWidget {
  const FoodAddPage({super.key, required this.food});

  final Food food;

  @override
  State<FoodAddPage> createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  @override
  void initState() {
    // TODO: implement initState
    textEditingController.text = food.kcal.toString();
    memoEditingController.text = "${food.memo}";
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Food get food => widget.food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              food.memo = memoEditingController.text;
              food.kcal = int.parse(textEditingController.text);

              final dbhelper = DataBaseHelper.instance;
              await dbhelper.insertFood(food);
              Navigator.of(context).pop();
            },
            child: Text("저장"),
          ),
        ],
      ),
      body: Column(
        children: [
          Text("어떤 음식을 드셨나요?"),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("칼로리"),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: textEditingController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              selectImage();
            },
            child: Container(
              child: food.image.isEmpty
                  ? AspectRatio(
                      child: Image.asset("assets/img/rice.png"),
                      aspectRatio: 1,
                    )
                  : AspectRatio(
                      child: Image.file(File(food.image)),
                      aspectRatio: 1,
                    ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CupertinoSegmentedControl(
              groupValue: food.type,
              onValueChanged: (int value) {
                setState(() {
                  food.type = value;
                });
              },
              children: {
                0: Text("아침"),
                1: Text("점심"),
                2: Text("저녁"),
                3: Text("간식"),
              },
            ),
          ),
          Column(
            children: [
              Text("메모"),
              SizedBox(
                height: 200,
                child: TextField(
                  maxLines: 10,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: memoEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final XFile pickedFile =
          await _picker.pickImage(source: ImageSource.gallery) ??
              XFile(food.image);
      setState(() {
        food.image = pickedFile.path;
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

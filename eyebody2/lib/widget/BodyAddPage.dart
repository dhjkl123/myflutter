import 'dart:io';

import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/data/database.dart';
import 'package:eyebody2/data/query.dart';
import 'package:eyebody2/style.dart';
import 'package:eyebody2/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EyebodyAddPage extends StatefulWidget {
  final Eyebody eyebody;

  const EyebodyAddPage({super.key, required this.eyebody});

  @override
  State<EyebodyAddPage> createState() => _EyebodyAddPageState();
}

class _EyebodyAddPageState extends State<EyebodyAddPage> {
  @override
  // TODO: implement widget
  Eyebody get eyebody => super.widget.eyebody;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    memoController.text = eyebody.memo!;
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
                  Query query = Query(tableName: DatabaseHelper.bodyTable);

                  eyebody.memo = memoController.text;

                  query.insertDataById(eyebody);
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
                    child: eyebody.image!.length == 0
                        ? Image.asset("assets/img/eyebody.png")
                        : Image.file(File(eyebody.image!)),
                    aspectRatio: 2,
                  ),
                  onTap: () {
                    selectImage();
                  },
                ),
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
  //   String _t = eyebody.time.toString();

  //   String _m = _t.substring(_t.length - 2);
  //   String _h = _t.substring(0, _t.length - 2);

  //   TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
  //   return "${time.hour > 11 ? "오후" : "오전"}${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)}";
  // }

  Future<void> selectImage() async {
    final _img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_img != null) {
      setState(() {
        eyebody.image = _img.path;
      });
    }
  }
}

import 'dart:io';

import 'package:eyebody/data/data.dart';
import 'package:eyebody/data/databasehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EyeBodyAddPage extends StatefulWidget {
  const EyeBodyAddPage({super.key, required this.eyeBody});

  final EyeBody eyeBody;

  @override
  State<EyeBodyAddPage> createState() => _EyeBodyAddPageState();
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = eyeBody.weight.toString();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();

  EyeBody get eyeBody => widget.eyeBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              eyeBody.weight = int.parse(textEditingController.text);

              final dbhelper = DataBaseHelper.instance;
              await dbhelper.insertEyeBody(eyeBody);
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
              child: eyeBody.image.isEmpty
                  ? AspectRatio(
                      child: Image.asset("assets/img/body.png"),
                      aspectRatio: 1,
                    )
                  : AspectRatio(
                      child: Image.file(File(eyeBody.image)),
                      aspectRatio: 1,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final XFile pickedFile =
          await _picker.pickImage(source: ImageSource.gallery) ??
              XFile(eyeBody.image);
      setState(() {
        eyeBody.image = pickedFile.path;
      });
    } catch (e) {
      print(e);
    }

    // final __img =
    //     await MultipleImagesPicker.pickImages(maxImages: 1, enableCamera: true);
    // if (__img.length < 1) return;

    // setState(() {
    //   eyeBody.image = __img.first.identifier!;
    // });
  }
}

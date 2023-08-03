import 'package:eyebody/data/data.dart';
import 'package:eyebody/data/databasehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FoodAddPage extends StatefulWidget {
  const FoodAddPage({super.key, required this.food});

  final Food food;

  @override
  State<FoodAddPage> createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();

  List<Asset> images = <Asset>[];
  Food get food => widget.food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              food.memo = memoEditingController.text;
              food.kcal = int.parse(textEditingController.text) ?? 0;

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
                  : AssetThumb(
                      asset: Asset(food.image, "food.png", 0, 0),
                      width: 300,
                      height: 300,
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
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus mediaStatus = await Permission.mediaLibrary.request();
    //PermissionStatus photoStatus = await Permission.photos.request();
    // await Permission.mediaLibrary.request();
    // await Permission.photos.request();

    bool tmp = cameraStatus.isGranted;
    tmp = mediaStatus.isGranted;
    //tmp = photoStatus.isGranted;

    if (cameraStatus.isGranted && mediaStatus.isGranted) {
      try {
        resultList = await MultipleImagesPicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }
    }

    // final __img =
    //     await MultipleImagesPicker.pickImages(maxImages: 1, enableCamera: true);
    // if (__img.length < 1) return;

    // setState(() {
    //   food.image = __img.first.identifier!;
    // });
  }
}

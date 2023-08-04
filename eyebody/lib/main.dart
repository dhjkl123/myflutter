import 'dart:io';

import 'package:eyebody/data/data.dart';
import 'package:eyebody/data/databasehelper.dart';
import 'package:eyebody/utils.dart';
import 'package:eyebody/view/body.dart';
import 'package:eyebody/view/food.dart';
import 'package:eyebody/view/workout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int curidx = 0;

  List<Food> todayFood = [];
  List<WorkOut> todayWorkout = [];
  List<EyeBody> todayEyeBody = [];

  List<String> foodtype = ["아침", "점심", "저녁", "간식"];

  DateTime time = DateTime.now();
  DateTime curday = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    getFoodHistory();
    super.initState();
  }

  Future<void> getFoodHistory() async {
    todayFood = await DataBaseHelper.instance
        .queryFoodByDate(Utils.getFormatTime(time));
    todayWorkout = await DataBaseHelper.instance
        .queryWorkOutByDate(Utils.getFormatTime(time));
    todayEyeBody = await DataBaseHelper.instance
        .queryEyeBodyByDate(Utils.getFormatTime(time));
    setState(() {});
  }

  Future<void> getAllHistory() async {
    todayFood = await DataBaseHelper.instance.queryAllFood();
    todayWorkout = await DataBaseHelper.instance.queryAllWorkOut();
    todayEyeBody = await DataBaseHelper.instance.queryAllEyeBody();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          setState(() {
            curidx = index;
          });
          await getFoodHistory();
        },
        currentIndex: curidx,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "오늘",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "기록",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "통계",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            label: "갤러리",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    TextButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FoodAddPage(
                                  food: Food(
                                    id: null,
                                    date: Utils.getFormatTime(time),
                                    type: 0,
                                    kcal: 0,
                                    image: "",
                                    memo: "",
                                  ),
                                )));
                        getHistoryPage();
                        setState(() {});
                      },
                      child: Text("식단"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => WorkoutAddPage(
                                  workOut: WorkOut(
                                    id: -1,
                                    date: Utils.getFormatTime(time),
                                    time: 0,
                                    image: "",
                                    memo: "",
                                    name: "",
                                  ),
                                )));
                        getHistoryPage();
                        setState(() {});
                      },
                      child: Text("운동"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EyeBodyAddPage(
                                  eyeBody: EyeBody(
                                    id: -1,
                                    date: Utils.getFormatTime(time),
                                    weight: 0,
                                    image: "",
                                  ),
                                )));
                        getHistoryPage();
                        setState(() {});
                      },
                      child: Text("눈바디"),
                    ),
                  ]),
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage() {
    if (curidx == 0) {
      setState(() {
        time = DateTime.now();
      });
      return getMainPage();
    } else if (curidx == 1) {
      setState(() {
        time = DateTime.now();
        curday = DateTime.now();
      });
      return getHistoryPage();
    } else if (curidx == 2) {
      setState(() {
        getAllHistory();
      });
      return getChartPage();
    } else if (curidx == 3) {
      setState(() {
        getAllHistory();
      });
      return getGallaryPage();
    } else {
      return SizedBox();
    }
  }

  Widget getMainPage() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var food in todayFood)
                Card(
                  widget: FoodAddPage(food: food),
                  imgPath: food.image,
                  text: foodtype[food.type],
                )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var w in todayWorkout)
                Card(
                  widget: WorkoutAddPage(workOut: w),
                  imgPath: w.image,
                  text: w.name,
                )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var e in todayEyeBody)
                Card(
                  widget: EyeBodyAddPage(eyeBody: e),
                  imgPath: e.image,
                  text: e.weight.toString() + "kg",
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget getHistoryPage() {
    return SingleChildScrollView(
      child: Column(children: [
        TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                curday = selectedDay;
                time = selectedDay;
                getFoodHistory();
              });
            },
            selectedDayPredicate: (DateTime day) {
              return isSameDay(curday, day);
            }),
        getMainPage(),
      ]),
    );
  }

  Widget getChartPage() {
    return Column(
      children: [
        getMainPage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("총 기록 식단 수 :  ${todayFood.length}"),
            Text("총 기록 운동 수 :  ${todayWorkout.length}"),
            Text("총 기록 눈바디 수 :  ${todayEyeBody.length}"),
          ],
        ),
      ],
    );
  }

  Widget getGallaryPage() {
    return GridView.count(
      crossAxisCount: 3,
      children: [
        for (var eb in todayEyeBody)
          Card(
            imgPath: eb.image,
            text: eb.weight.toString() + "kg",
            widget: EyeBodyAddPage(
              eyeBody: eb,
            ),
          )
      ],
    );
  }
}

class Card extends StatelessWidget {
  const Card(
      {super.key,
      required this.imgPath,
      required this.text,
      required this.widget});

  final String imgPath;
  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => widget,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(File(imgPath)),
            ),
            Positioned.fill(
                child: Container(
              color: Colors.black38,
            )),
            Positioned.fill(
                child: Text(
              text,
              style: TextStyle(color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/data/database.dart';
import 'package:eyebody2/data/query.dart';
import 'package:eyebody2/utils.dart';
import 'package:eyebody2/widget/BodyAddPage.dart';
import 'package:eyebody2/widget/FoodAddPage.dart';
import 'package:eyebody2/widget/HomeWidget.dart';
import 'package:eyebody2/widget/WorkotuAddPage.dart';
import 'package:flutter/material.dart';

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
  final dbHelper = DatabaseHelper.instance;
  int curIndex = 0;
  DateTime dateTime = DateTime.now();

  List<Workout> workouts = [];
  List<Food> foods = [];
  List<Eyebody> bodies = [];
  Weight? weight;

  void getHistorise() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await Query<Food>(tableName: DatabaseHelper.foodTable)
        .queryDataByDate(_d, Food());

    bodies = await Query<Eyebody>(tableName: DatabaseHelper.bodyTable)
        .queryDataByDate(_d, Eyebody());

    workouts = await Query<Workout>(tableName: DatabaseHelper.workoutTable)
        .queryDataByDate(_d, Workout());

    // weight = await Query(tableName: DatabaseHelper.weight).queryDataByDate(_d)
    //     as Weight;

    setState(() {});
  }

  @override
  void initState() {
    getHistorise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return SizedBox(
                width: 500,
                height: 250,
                child: Column(
                  children: [
                    TextButton(
                      child: Text("식단"),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => FoodAddPage(
                              food: Food(
                                date: Utils.getFormatTime(DateTime.now()),
                                kcal: 0,
                                memo: "",
                                type: 0,
                                image: "",
                                time: 1130,
                                meal: 0,
                              ),
                            ),
                          ),
                        );
                        getHistorise();
                      },
                    ),
                    TextButton(
                      child: Text("운동"),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => WorkoutAddPage(
                              workout: Workout(
                                date: Utils.getFormatTime(DateTime.now()),
                                part: 0,
                                memo: "",
                                intense: 0,
                                calorie: 0,
                                time: 1130,
                                name: "",
                                type: 0,
                              ),
                            ),
                          ),
                        );
                        getHistorise();
                      },
                    ),
                    TextButton(
                      child: Text("몸무게"),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text("눈바디"),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => EyebodyAddPage(
                              eyebody: Eyebody(
                                date: Utils.getFormatTime(DateTime.now()),
                                image: "",
                                memo: "",
                              ),
                            ),
                          ),
                        );
                        getHistorise();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "오늘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "몸무게"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "통계"),
        ],
        currentIndex: curIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            curIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (curIndex == 0) {
      return HomeWidget(DateTime.now(), foods, workouts, bodies, weight);
    } else {
      return Container();
    }
  }
}

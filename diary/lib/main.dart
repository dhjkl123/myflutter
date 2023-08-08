import 'package:diary/data/database.dart';
import 'package:diary/data/diary.dart';
import 'package:diary/data/util.dart';
import 'package:diary/write.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'firebase_options.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

  tz.initializeTimeZones();

  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel("fastcampus", "eyebody");
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
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
  int selectindex = 0;
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Diary emptyDiary =
      Diary(title: "", memo: "", category: "", date: -1, status: -1, image: "");

  late Diary todayDiary;
  late Diary historyDiary;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _time = DateTime.now();

  List<Diary> allDiarires = [];

  List<String> statusImg = [
    "asset/img/ico-weather_2.png",
    "asset/img/ico-weather_3.png",
    "asset/img/ico-weather.png",
  ];

  void getTodayDriay() async {
    List<Diary> diary =
        await databaseHelper.getDiaryByDate(Util.getForamtTime(DateTime.now()));
    if (diary.isNotEmpty) {
      todayDiary = diary.first;
    }

    setState(() {});
  }

  void getAllDriay() async {
    allDiarires = await databaseHelper.getAllData();

    setState(() {});
  }

  Future<bool?> initNotification() async {
    var initSettingAdroid = AndroidInitializationSettings("app_icon");

    var initSetting = InitializationSettings(android: initSettingAdroid);

    await flutterLocalNotificationsPlugin.initialize(initSetting);

    setScheduling();

    return true;
  }

  @override
  void initState() {
    todayDiary = emptyDiary;
    historyDiary = emptyDiary;
    getTodayDriay();
    initNotification();
    super.initState();
  }

  void setScheduling() async {
    var android = AndroidNotificationDetails("fastcampus", "eyebody",
        importance: Importance.max, priority: Priority.max);

    NotificationDetails details = NotificationDetails(android: android);

    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "오늘 다이어트를 기록하세요",
        "앱에서 기록을 알려주세요",
        tz.TZDateTime.from(
          DateTime.now().add(Duration(seconds: 10)),
          tz.local,
        ),
        androidAllowWhileIdle: true,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: "eyebody",
        matchDateTimeComponents: DateTimeComponents.time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(child: getPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectindex == 0) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => DiaryWritePage(
                    diary: todayDiary.status == -1
                        ? Diary(
                            title: "",
                            memo: "",
                            category: "",
                            date: Util.getForamtTime(DateTime.now()),
                            status: 0,
                            image: "asset/img/b1.jpg")
                        : todayDiary),
              ),
            );
            getTodayDriay();
          } else {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => DiaryWritePage(
                    diary: historyDiary.status == -1
                        ? Diary(
                            title: "",
                            memo: "",
                            category: "",
                            date: Util.getForamtTime(_time),
                            status: 0,
                            image: "asset/img/b1.jpg")
                        : historyDiary),
              ),
            );
            getDiaryByDate(_time);
          }

          getTodayDriay();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectindex,
        onTap: (index) {
          setState(() {
            selectindex = index;
          });

          if (selectindex == 2) {
            getAllDriay();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "오늘",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: "기록",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: "통계",
          )
        ],
      ),
    );
  }

  Widget getPage() {
    if (selectindex == 0) {
      return getTodayPage();
    } else if (selectindex == 1) {
      return getHistoryPage();
    } else {
      return getChartPage();
    }
  }

  void getDiaryByDate(DateTime date) async {
    List<Diary> d =
        await databaseHelper.getDiaryByDate(Util.getForamtTime(date));
    d.isEmpty ? historyDiary = emptyDiary : historyDiary = d.first;
  }

  Widget getTodayPage() {
    if (todayDiary.status == -1) {
      return Container(
        child: Text("일기를 작성해주세요."),
      );
    }
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              todayDiary.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateTime.now().month}.${DateTime.now().day}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        statusImg[todayDiary.status],
                        fit: BoxFit.contain,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayDiary.title,
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        todayDiary.memo,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getHistoryPage() {
    return Container(
      child: ListView.builder(
          itemCount: 2,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      print(selectedDay);
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      getDiaryByDate(selectedDay);
                      _time = selectedDay;
                    });
                  },
                  selectedDayPredicate: (DateTime day) {
                    // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                    return isSameDay(_selectedDay, day);
                  },
                ),
              );
            } else if (idx == 1) {
              if (historyDiary.status == -1) return SizedBox();
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_time.month}.${_time.day}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Image.asset(
                          statusImg[historyDiary.status],
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          historyDiary.title,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          historyDiary.memo,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Image.asset(
                          historyDiary.image,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget getChartPage() {
    return Container(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          if (index == 0) {
            return Container(
              child: Row(children: [
                for (var status in statusImg)
                  Container(
                    child: Column(children: [
                      Image.asset(
                        status,
                        fit: BoxFit.contain,
                      ),
                      Text(
                          "${allDiarires.where((element) => statusImg[element.status] == status).length} 개")
                    ]),
                  )
              ]),
            );
          } else if (index == 1) {
            return SingleChildScrollView(
              child: Row(
                children: [
                  for (var d in allDiarires)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        d.image,
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

import 'package:cloth/LocationPage.dart';
import 'package:cloth/api.dart';
import 'package:cloth/clothpage.dart';
import 'package:cloth/data/preference.dart';
import 'package:cloth/data/weather.dart';
import 'package:cloth/util.dart';
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
  List<String> clothes = [
    "assets/img/shirts.png",
    "assets/img/jumper.png",
    "assets/img/pants.png"
  ];

  List<ClothTmp> tmpCloth = [];

  List<Weather> weather = [];

  late Weather curWeather;

  List<String> sky = [
    "assets/img/sky1.png",
    "assets/img/sky2.png",
    "assets/img/sky3.png",
    "assets/img/sky4.png",
  ];

  List<Color> color = [
    Color(0xFFf78144),
    Color(0xff1d9fea),
    Color(0xff523de4),
    Color(0xff587d9a),
  ];

  List<String> status = ["날이 아주 좋아요!", "산책하기 좋겠어요!", "오늘은 흐리네요", "우산 꼭 챙겨요"];

  int level = 0;
  LocationData locationData = LocationData("강남구", 0, 0, 37.498122, 127.027565);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
  }

  void getWeather() async {
    Map<String, int> xy = Utils.latLngToXY(locationData.lat, locationData.lng);
    final pref = Preference();
    tmpCloth = await pref.getTmp();

    final now = DateTime.now();
    int time = int.parse("${now.hour + 9}00");
    int time2 = int.parse("${now.hour + 9}10");

    String strTime;

    if (time2 > 2300) {
      strTime = "2300";
    } else if (time2 > 2000) {
      strTime = "2000";
    } else if (time2 > 1700) {
      strTime = "1700";
    } else if (time2 > 1400) {
      strTime = "1400";
    } else if (time2 > 1100) {
      strTime = "1100";
    } else if (time2 > 800) {
      strTime = "0800";
    } else if (time2 > 500) {
      strTime = "0500";
    } else {
      strTime = "0200";
    }

    var api = WeatherApi();
    weather = await api.getWeather(xy["nx"]!, xy["ny"]!, 20230803, strTime);

    weather.removeWhere((element) => element.time < time);

    curWeather = weather.first;

    clothes =
        tmpCloth.firstWhere((element) => element.tmp < curWeather.tmp).cloth;
    level = getLevel(curWeather);
    setState(() {});
  }

  int getLevel(Weather weather) {
    int sky = weather.sky;

    if (sky > 8) {
      return 3;
    } else if (sky > 5) {
      return 2;
    } else if (sky > 2) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ClothPage()));
              getWeather();
            },
            icon: Icon(Icons.category),
          )
        ],
      ),
      backgroundColor: color[level],
      body: weather.isEmpty
          ? Center(
              child: Text(
              "날씨를 불러오는 중입니다.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ))
          : Column(children: [
              SizedBox(
                height: 50,
              ),
              Text(
                locationData.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                sky[curWeather.sky],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    curWeather.tmp.toString() + "℃",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        Utils.stringToDateTime(curWeather.date),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        status[level],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "오늘 어울리는 복장을 추천해드려요.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var c in clothes)
                    Container(
                      //padding: EdgeInsets.all(3),
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        c,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var w in weather)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${w.tmp}℃",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${w.pop}%",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: Image.asset(sky[getLevel(w)]),
                            ),
                            Text(
                              "${w.time}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              )
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LocationData data = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => LocationPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:admob_flutter/admob_flutter.dart';
import 'package:dust/data/api.dart';
import 'package:dust/locationpage.dart';
import 'package:flutter/material.dart';

import 'data/mise.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();
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
  List<Color> colors = [
    Color(0xFF0077C2),
    Color(0xff009ba9),
    Color(0xFFfe6300),
    Color(0xFFd80019),
  ];

  List<String> icon = [
    "asset/img/happy.png",
    "asset/img/sad.png",
    "asset/img/bad.png",
    "asset/img/angry.png",
  ];

  List<String> status = [
    "좋음",
    "보통",
    "나쁨",
    "매우나쁨",
  ];

  String stationName = "구로구";

  List<Mise> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMiseData();
  }

  int getStatus(Mise mise) {
    if (mise.pm10 > 150) {
      return 3;
    } else if (mise.pm10 > 80) {
      return 2;
    } else if (mise.pm10 > 30) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String loc = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => LocationPage()));
          if (loc.isNotEmpty) {
            stationName = loc;
            getMiseData();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage() {
    if (data.isEmpty) {
      return SizedBox();
    }

    int _status = getStatus(data.first);

    return Container(
      color: colors[_status],
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "현재 위치",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "[${stationName}]",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 200,
              child: Image.asset(
                icon[_status],
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              status[_status],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "통합 환경 대기 지수 : ${data.first.khai}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Container(
                //margin: EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (var d in data)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              d.dataTime.replaceAll(" ", "\n"),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            child: Image.asset(
                              icon[_status],
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${d.pm10} ug/m2",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                  ]),
                ),
              ),
            ),
            AdmobBanner(
                adUnitId: AdmobBanner.testAdUnitId,
                //adUnitId: "ca-app-pub-1874846187942175/4682383093",
                adSize: AdmobBannerSize.BANNER),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  void getMiseData() async {
    MiseApi api = MiseApi();
    data = await api.getMiseData(stationName);
    data.removeWhere((element) => element.pm10 == 0);
    setState(() {});
  }
}

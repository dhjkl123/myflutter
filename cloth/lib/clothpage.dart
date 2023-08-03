import 'package:cloth/data/preference.dart';
import 'package:flutter/material.dart';

import 'data/weather.dart';

class ClothPage extends StatefulWidget {
  const ClothPage({super.key});

  @override
  State<ClothPage> createState() => _ClothPageState();
}

class _ClothPageState extends State<ClothPage> {
  List<ClothTmp> clothes = [];

  List<List<String>> sets = [
    ["assets/img/shirts.png", "assets/img/jumper.png", "assets/img/pants.png"],
    ["assets/img/long.png", "assets/img/shirts.png", "assets/img/pants.png"],
    ["assets/img/shirts.png", "assets/img/short.png", "assets/img/jumper.png"]
  ];

  void getCloth() async {
    final pref = Preference();
    clothes = await pref.getTmp();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCloth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          for (int i = 0; i < clothes.length; i++)
            Column(
              children: [
                Text("${clothes[i].tmp}℃"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var cl in clothes[i].cloth)
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      for (var s in sets)
                                        InkWell(
                                          onTap: () async {
                                            clothes[i].cloth = s;
                                            final pref = Preference();
                                            await pref.setTmp(clothes[i]);
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              for (var l in s)
                                                Container(
                                                  //padding: EdgeInsets.all(3),
                                                  width: 70,
                                                  height: 70,
                                                  child: Image.asset(
                                                    l,
                                                  ),
                                                )
                                            ],
                                          ),
                                        )
                                    ],
                                  )),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("닫기"),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            cl,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

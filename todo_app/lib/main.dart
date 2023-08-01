import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/todo.dart';
import 'package:todo_app/data/util.dart';
import 'package:todo_app/write.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectindex = 0;

  List<Todo> todos = [
    // Todo(
    //   title: "패스트캠퍼스 강의듣기1",
    //   memo: "앱 개발 입문 강의 듣기1",
    //   category: "공부",
    //   color: Colors.redAccent.value,
    //   done: 0,
    //   date: 20210709,
    // ),
    // Todo(
    //   title: "패스트캠퍼스 강의듣기2",
    //   memo: "앱 개발 입문 강의 듣기2",
    //   category: "공부",
    //   color: Colors.blueAccent.value,
    //   done: 1,
    //   date: 20210709,
    // )
  ];

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  void getTodayTodo() async {
    todos =
        await databaseHelper.getTodoByDate(Util.getForamtTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodo = await databaseHelper.getAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Todo todo = await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => TodoWritePage(
                  todo: Todo(
                      title: "",
                      memo: "",
                      category: "",
                      color: 0,
                      done: 0,
                      date: Util.getForamtTime(
                          DateTime.now().subtract(Duration(days: 1)))))));
          getTodayTodo();
          setState(() {});
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectindex,
          onTap: (idx) {
            if (idx == 1) {
              getAllTodo();
            }

            setState(() {
              selectindex = idx;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              label: "오늘",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: "기록",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "더보기",
            ),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage() {
    if (selectindex == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  Widget getMain() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 30,
            ),
            child: Text(
              "오늘 하루",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (idx == 1) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var todo in todos)
                  if (todo.done == 0)
                    InkWell(
                      onLongPress: () async {
                        Todo t = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => TodoWritePage(todo: todo)));
                        getTodayTodo();
                        setState(() {});
                      },
                      onTap: () async {
                        setState(() {
                          if (todo.done == 0) {
                            todo.done = 1;
                          } else {
                            todo.done = 0;
                          }
                        });

                        await databaseHelper.insertTodo(todo);
                      },
                      child: TodoCard(todo: todo),
                    )
              ],
            ),
          );
        } else if (idx == 2) {
          return Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 30,
            ),
            child: Text(
              "완료된 하루",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (idx == 3) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var todo in todos)
                  if (todo.done == 1)
                    InkWell(
                      onLongPress: () async {
                        Todo t = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => TodoWritePage(todo: todo)));
                        getTodayTodo();
                        setState(() {});
                      },
                      onTap: () async {
                        setState(() {
                          if (todo.done == 1) {
                            todo.done = 0;
                          } else {
                            todo.done = 1;
                          }
                        });

                        await databaseHelper.insertTodo(todo);
                      },
                      child: TodoCard(todo: todo),
                    )
              ],
            ),
          );
        }
      },
      itemCount: 4,
    );
  }

  List<Todo> allTodo = [];

  Widget getHistory() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TodoCard(todo: allTodo[index]);
      },
      itemCount: allTodo.length,
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  late int now;
  late DateTime time;

  TodoCard({super.key, required this.todo}) {
    now = Util.getForamtTime(DateTime.now());
    time = Util.numToDateTime(todo.date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
          color: Color(todo.color), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              todo.done == 0 ? "미완료" : "완료",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          height: 2,
        ),
        Text(
          todo.memo,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        now == todo.date
            ? Container()
            : Text(
                "${time.month}월 ${time.day}일",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
      ]),
    );
  }
}

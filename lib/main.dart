import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tb;
  int hour = 0;
  int minute = 0;
  int second = 0;
  String timeToDisplay = "";
  bool isStart = true;
  bool isStop = true;
  int timeForTimer;
  bool canceltimer = false;
  final dur = const Duration(seconds: 1);

  @override
  void initState() {
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start() {
    setState(() {
      isStart = false;
      isStop = false;
    });
    timeForTimer = ((hour * 3600) + (minute * 60) + second);
    Timer.periodic(dur, (Timer t) {
      setState(() {
        if (timeForTimer < 1 || canceltimer == true) {
          t.cancel();
          // hour = 0;
          // minute = 0;
          // second = 0;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        } else if (timeForTimer < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }
      });
    });
  }

  void stop() {
    setState(() {
      isStart = true;
      isStop = true;
      canceltimer = true;
    });
  }

  Widget timer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text("HH",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 23,
                        value: hour,
                        onChanged: (val) {
                          setState(() {
                            hour = val;
                          });
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text("MM",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 60,
                        value: minute,
                        onChanged: (val) {
                          setState(() {
                            minute = val;
                          });
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text("SS",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 60,
                        value: second,
                        onChanged: (val) {
                          setState(() {
                            second = val;
                          });
                        },
                      )
                    ],
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: Text(
              timeToDisplay,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.0,
                    vertical: 12.0,
                  ),
                  onPressed: isStart ? start : null,
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.0,
                    vertical: 12.0,
                  ),
                  onPressed: isStop ? null : stop,
                  child: Text(
                    "Stop",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clock",
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: [
            Text(
              "Timer",
            ),
            Text(
              "Stopwatch",
            )
          ],
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          unselectedLabelColor: Colors.white60,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: [
          timer(),
          Text(
            "Stop watch",
          ),
        ],
        controller: tb,
      ),
    );
  }
}




import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sample_alarm/alarm_page/new_alarm_screen.dart';
import 'package:sample_alarm/char_page/chart_screen.dart';
import 'package:sample_alarm/model/data_alarm.dart';
import 'package:sample_alarm/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  int  _counter = 0;
  static SendPort uiSendPort;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  List<DataAlarm> listAlarm = [];




  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      AndroidAlarmManager.initialize();
    }
    listAlarm.add(DataAlarm(
      id: "1",
      x: "12:00",
      y: 0,
      alarmName: "First Alarm",
      descript: "This is my first Alarm",
      alarmDate: DateTime.now()
    ));
    initPortListener();
    initFlutterLocalNotification();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Alarm"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChartSCreen(data: listAlarm,)));
            }, child: Text("Chart",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,

            ),
          )
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listAlarm[index].alarmName, style: TextStyle(fontSize: 20),),
                      SizedBox(
                        height: 12,
                      ),
                      Text(listAlarm[index].descript == null
                          ? ''
                          : listAlarm[index].descript
                      )
                    ],
                  ),
                  Text("${listAlarm[index].alarmDate.hour} : ${listAlarm[index].alarmDate.minute}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple
                  ),)
                ],
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          elevation: 2,
        );
      },
        itemCount: listAlarm.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DataAlarm result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewAlarmScreen())
          );
          if(result != null){
            setState(() {
              listAlarm.add(result);
            });
          }
        },
        child: Icon(
          Icons.add
        ),
      ),

    );
  }


  void initPortListener() {
    port.listen((message) async {
      return await _incrementCounter();
    });
  }


  void initFlutterLocalNotification() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher_playstore');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }


  /*
  On receive notification for IOS
   */
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              print("IOS Local Notificaiton");
            },
          )
        ],
      ),
    );
  }



  /*
  on select local notification
   */
  Future onSelectNotification(String payload) async {
    await AndroidAlarmManager.cancel(1);
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ChartSCreen(data: listAlarm,)),
    );
  }


  /*
  callback when aalam
   */
  static Future<void> callbackAlarm() async {
    print('Alarm fired!');

    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
    doShowLocalNotification();
  }


  static Future<void> doShowLocalNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_launcher_playstore',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('ringtone'),
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500

    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _incrementCounter() async {
    print('Increment counter!');

    // Ensure we've loaded the updated count from the background isolate.
    await prefs.reload();

    setState(() {
      _counter++;
    });
  }






}

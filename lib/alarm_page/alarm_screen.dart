


import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sample_alarm/alarm_page/new_alarm_screen.dart';
import 'package:sample_alarm/char_page/chart_screen.dart';
import 'package:sample_alarm/model/data_alarm.dart';
import 'package:sample_alarm/main.dart';
import 'package:sample_alarm/util/base_textstyle.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  static SendPort uiSendPort;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  static List<DataAlarm> listDataAlarm = [];

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      AndroidAlarmManager.initialize();
    }
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChartSCreen(data: listDataAlarm,)));
            }, child: Text("Chart",
            style: BaseStyle.ts12w600White,
          )
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return listDataAlarm.length == 0
            ? Center(
          child: Text('Alarm is empty'),
        )
            : Card(
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
                      Text(listDataAlarm[index].alarmName, style: TextStyle(fontSize: 20),),
                      SizedBox(
                        height: 12,
                      ),
                      Text(listDataAlarm[index].descript == null
                          ? ''
                          : listDataAlarm[index].descript
                      )
                    ],
                  ),
                  Text("${listDataAlarm[index].alarmDate.hour} : ${listDataAlarm[index].alarmDate.minute}",
                    style: BaseStyle.ts22w600purple)
                ],
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          elevation: 1,
        );
      },
        itemCount: listDataAlarm.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DataAlarm result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewAlarmScreen())
          );
          if(result != null){
            print(result.alarmDate);
            setState(() {
              listDataAlarm.add(result);
            });
            await AndroidAlarmManager.oneShotAt(result.alarmDate, int.parse(result.id), callbackAlarm);
          }
        },
        child: Icon(
          Icons.add
        ),
      ),

    );
  }


  /*
  init port listener
   */
  void initPortListener() {
    port.listen((message) async {
      return await updateYaxisAlarm(message);
    });
  }



  /*
  init flutter local notification
   */
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
    print('on select $payload');
    await AndroidAlarmManager.cancel(int.parse(payload));
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ChartSCreen(data: listDataAlarm,)),
    );
  }


  /*
  callback after alarm fired
   */
  static Future<void> callbackAlarm(int idAlarm) async {
    print('Alarm fired! + $idAlarm');

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(idAlarm);
    doShowLocalNotification(idAlarm.toString());
    AndroidAlarmManager.periodic(Duration.zero, idAlarm, callbackAlarm);
  }


  /*
  show local notification function
   */
  static Future<void> doShowLocalNotification(String idAlarm) async {
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
        int.parse(idAlarm), 'plain title', 'plain body', platformChannelSpecifics,
        payload: idAlarm);
  }


  /*
  called update elementY when receive message port
   */
  Future<void> updateYaxisAlarm(int message) async {
    updateElementInsideList(message);
  }



  /*
  Update value inside element in list
   */
  void updateElementInsideList(int idAlarm) {

    for(int i = 0; i< listDataAlarm.length ;i++) {
      print(listDataAlarm[i].id);
    }

    int index = listDataAlarm.indexWhere((element) => element.id == idAlarm.toString());
    DataAlarm current = listDataAlarm[index];
    current.yAxis +=3;
    listDataAlarm[listDataAlarm.indexWhere((element) => element.id == idAlarm.toString())] = current;

  }

}

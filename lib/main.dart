import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sample_alarm/alarm_page/alarm_screen.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName
  );

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlarmScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

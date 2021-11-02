
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../model/data_alarm.dart';

class ChartSCreen extends StatefulWidget {

  final List<DataAlarm> data;
  const ChartSCreen({Key key,@required this.data,}) : super(key: key);

  @override
  _ChartSCreenState createState() => _ChartSCreenState();
}

class _ChartSCreenState extends State<ChartSCreen> {
  bool animation;

  @override
  Widget build(BuildContext context) {

    List<charts.Series<DataAlarm, String>> series = [
      charts.Series(
        id: "subs",
        data: widget.data,
        domainFn: (DataAlarm series,_) => series.xAxis,
        measureFn: (DataAlarm series, _) => series.yAxis,

      )
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm"),
      ),
      body: Container(
        child: charts.BarChart(series, animate: true,),
      )
    );
  }


}





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

  @override
  Widget build(BuildContext context) {

    List<charts.Series<DataAlarm, String>> series = [
      charts.Series(
        id: "subs",
        data: widget.data,
        domainFn: (DataAlarm series,_) => series.xAxis,
        measureFn: (DataAlarm series, _) => series.yAxis,
        labelAccessorFn: (DataAlarm series, _) => '${series.yAxis.toString()}s'
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Chart Alarm Duration"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text('Berikut adalah diagram yang menunjukkan durasi alarm berbunyi sebelum user menekan/mengklik notification message'),
          ),
          Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height*0.6,
            child: charts.BarChart(
              series,
              animate: false,
              barRendererDecorator: charts.BarLabelDecorator<String>(),
            ),
          ),
        ],
      )
    );
  }


}




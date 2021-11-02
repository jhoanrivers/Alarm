class DataAlarm {
  String id;
  int yAxis;
  String xAxis;
  String alarmName;
  String descript;
  DateTime alarmDate;

  DataAlarm({
    String id,
    String x,
    int y,
    alarmName,
    descript,
    alarmDate,
  }){
    this.id = id;
    this.xAxis = x;
    this.yAxis = y;
    this.alarmName = alarmName;
    this.descript = descript;
    this.alarmDate = alarmDate;
  }

}
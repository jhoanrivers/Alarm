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
    String alarmName,
    String description,
    DateTime alarmDate,
  }){
    this.id = id;
    this.xAxis = x;
    this.yAxis = y;
    this.alarmName = alarmName;
    this.descript = description;
    this.alarmDate = alarmDate;
  }

}
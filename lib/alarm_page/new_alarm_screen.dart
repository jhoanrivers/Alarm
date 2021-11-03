


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sample_alarm/model/data_alarm.dart';
import 'package:sample_alarm/util/Validator.dart';
import 'package:sample_alarm/util/base_textstyle.dart';

class NewAlarmScreen extends StatefulWidget {
  const NewAlarmScreen({Key key}) : super(key: key);

  @override
  _NewAlarmScreenState createState() => _NewAlarmScreenState();
}

class _NewAlarmScreenState extends State<NewAlarmScreen> {

  TextEditingController alarmNameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  int hour;
  int minute;
  TimeOfDay selectedTime;
  DateTime now = DateTime.now();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;


  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPopScope,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: onWillPopScope,
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          title: Text('New Alarm'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAlarmNameWidget(),
              Divider(),
              buildAlarmDescription(),
              Divider(),
              buildAlarmTimeWidget(),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    var result = Validator.isValid(alarmNameController.text, hour, minute);
                    if(result){
                      DateTime currentDate =  new DateTime.now();
                      DataAlarm newData = DataAlarm(
                          id: Random().nextInt(10000).toString(),
                          x: "$hour:$minute",
                          y: 0,
                          alarmName: alarmNameController.text,
                          description: descriptionController.text,
                          alarmDate: DateTime(
                              currentDate.year,
                              currentDate.month,
                              currentDate.day,
                              hour,
                              minute
                          )
                      );

                      Navigator.pop(context, newData);
                    } else{
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: Text('Crete New Alarm'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16)
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }


  /*
  widget to show value hour and minute
   */
  dateTimeWidget(){
    return Row(
      children: [
        buildTextTime(hour == null
        ? "--"
        : hour.toString()),
        SizedBox(
          width: 6,
        ),
        buildTextTime(':'),
        SizedBox(
          width: 6,
        ),
        buildTextTime(minute == null
        ? '--'
        : minute.toString()),
      ],
    );
  }


  /*
  called time picker function to select time
   */
  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if(picked != null) {
      setState(() {
        selectedTime = picked;
         hour = selectedTime.hour;
         minute = selectedTime.minute;
      });
    }

  }

  /*
  widget for text time
   */
  Widget buildTextTime(String value){
    return Text(
      value,
      style: BaseStyle.ts22BlackBold,
    );
  }

  /*
  when app is closed
   */
  Future<bool> onWillPopScope() async{
    Navigator.pop(context,null);
    return true;
  }

  /*
  widget which show alarm name field
   */
  buildAlarmNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarm Name'),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          decoration: InputDecoration(
              hintText: "Input Alarm Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide()
              )
          ),
          controller: alarmNameController,
          autovalidateMode: autovalidateMode,
          validator: (value){
            if(value.isEmpty){
              return "Please insert alarm name";
            }
            return null;
          },
        ),
      ],
    );
  }

  /*
  widget for description field
   */
  buildAlarmDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarm Name'),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          decoration: InputDecoration(
              hintText: "Some description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide()
              )
          ),
          maxLines: 4,
          controller: descriptionController,
        ),
      ],
    );
  }

  /*
  widget which show alarm set time
   */
  buildAlarmTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarm Time'),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            dateTimeWidget(),
            TextButton(
                onPressed: (){
                  selectTime(context);
                },
                child: Text("Set Time")
            )
          ],
        )
      ],
    );
  }

}

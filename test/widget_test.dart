// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sample_alarm/main.dart';
import 'package:sample_alarm/util/Validator.dart';

void main() {


  /*
  Several unit test for validator create new alarm
   */
  test("Invalid caused empty and null hour and minute", (){
    var isValid = Validator.isValid('', null, null);
    expect(isValid, false);
  });


  test("Invalid cause null hour and minute", () {
    var isValid = Validator.isValid("Alarm Name", null, null);
    expect(isValid, false);
  });


  test("Invalid cause null minute", (){
    var isValid = Validator.isValid("Alarm Name", 10, null);
    expect(isValid, false);
  });

  test ("Valid cause notEmpty and not null hour and minute", () {
    var isValid = Validator.isValid("Alarm Name", 10, 20);
    expect(isValid, true);
  });


}

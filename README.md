# Jhoan River Alarm Sample

Device and Tools

- Flutter Stable 2.0.0
- Android Studio 4.1.1
- Dart SDK version: 2.12.0
- Tested on Realme XT - Android 11

## Introduction
 
For sure currently Flutter has come with his new spectacular version 2.5.0, but I hope you still can run this code on your local.
honestly nothing special needed to run this application. plug your phone to your device, compile and Voilaa.. I am sure it works properly :D (In Android), didnt test yet for IOS. I will also serve you apk link in google drive : https://drive.google.com/file/d/1adB9CVbJf63ig2YqNbc_RyW_NG7tUJ9g/view?usp=sharing


## How I Code It

As feature needed the apk have several functions. There are :
- Set Alarm 
- Show Local Notification
- Show chart for every alarm duration


Library used :
- android_alarm_manager: ^2.0.2 -> Alarm management
- flutter_local_notifications: ^4.0.1 -> show local notification
- charts_flutter: ^0.11.0 -> show chart

For easier development, I didnt save every alarms in local storage. just as temporary list alarm. so when app is killed, data will be gone :D

1. Alarm Manager
When user finish create new Alarm. AndroidAlarmManager.oneShotAt will be called after called once. I also called AndroidAlarmManger.periodic to loop the alarm and show local notification.

2. Local Notification
Local notification just just for show notification message when alarm is fired.

3. Charts
Easily, I just serve list item of every alarm, create chart series and add to widget charts.BarChart.. Voilaa.. it is done.


So, how do I record the length of duration for every alarm?

I used ringtone 3 second length.
When the first ringtone called -> means 3 second. Y value will be added as much 3. 
and for the next also will be add by 3
so just like:

for every periodic alarm called :
y = y+3

So that is all the explanation for every concept for creating this project.
for Demo app, you can access in :

Auhor,

Jhoan River 
 












 

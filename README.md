# Jhoan River Alarm Sample

Device and Tools

- Flutter Stable 2.0.0
- Android Studio 4.1.1
- Dart SDK version: 2.12.0
- Tested on Realme XT - Android 11

## Introduction
This is a sample application of alarm manager. It will allow user to set alarm, show notification when alarm is ringin and record duration of how long alarm rang.

For apk link in google drive : https://drive.google.com/file/d/11F0VlXhxGL_Vd5NM8ngEICyf0u_SXJds/view?usp=sharing
For Demo app, you can access in : https://youtu.be/muiLseRMZQs


## Functions

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



## Interfaces

1. Dashboard application
The first screen when open application will show an empty screen. It is because there is no list data/ alarm which will be show.
You can see the image below.

<img src="/assets/image1.jpeg" width="400">

2. To make new alarm. Click + button which is a float action button. And user will be directed to new screen create new alarm
<img src="/assets/image2.jpeg" width="400">

3. After user finished create new alarm. alarm will be show in user dashboard.
<img src="/assets/image3.jpeg" width="400">

4. While waiting, I create a second alarm. and so the first alarm just rank.
<img src="/assets/image4.jpeg" width="400">

5. When I click the notification. It will redirect user to chart page.
For every alarm ringing will take 3s long-time. In chat page shown that the duration of first alarm that has been clicked. by clicking the notification will stop the "ring duration". As you can see, the duration of the first alarm duration is 18s and the second alarm is 0s, because the second is not ring yet.
<img src="/assets/image5.jpeg" width="400">

6. And after the second alarm ring. I click it and it will redirect me to the chart page.
<img src="/assets/image6.jpeg" width="400">


So that is all the explanation for this project. For all your attention I say thank you.













 

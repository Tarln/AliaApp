import 'dart:convert';
import 'package:aliaapp/Home.dart';
import 'package:aliaapp/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aliaapp/ConsValue.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:workmanager/workmanager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالية',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget myWidget = Login(false);
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void setPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    UserCount = pref.getString("UserCount")!;
    ItemCount = pref.getString("ItemCount")!;
    OfferCount = pref.getString("OfferCount")!;
    isSave = pref.getBool("isSave")!;
    String data = pref.getString("data")!;
    Myuser = json.decode(data);
  }

  void setPrefColor() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Color1 = Color(int.parse(pref.getString("Color_1")!));
    Color2 = Color(int.parse(pref.getString("Color_2")!));
    Color3 = Color(int.parse(pref.getString("Color_3")!));
    Color4 = Color(int.parse(pref.getString("Color_4")!));
    ColorValue = (int.parse(pref.getString("ColorValue")!));
  }

  void autoLogIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getKeys().contains("isSave")) {
      isSave = pref.getBool("isSave")!;
      if (isSave) {
        setState(() {
          setPref();
          setPrefColor();
          myWidget = HomePage();
        });
      } else {
        setState(() {
          setPrefColor();
          myWidget = Login(true);
        });
      }
    } else {
      setState(() {
        changecolor(Colors.blue);
        myWidget = Login(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return myWidget;
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Local Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  @override
  void initState() {

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    flutterNotificationPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) async{
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              "Hello Everyone"
          ),
          content: Text(
              "$payload"
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(
                    "Notification with Default Sound"
                ),
                onPressed: () {
                  notificationDefaultSound();
                },
              ),

              RaisedButton(
                child: Text(
                    "Notification without Sound"
                ),
                onPressed: () {
                  notificationNoSound();
                },
              ),

              RaisedButton(
                child: Text(
                    "Notification with Custom Sound"
                ),
                onPressed: () {
                  notificationCustomSound();
                },
              ),

              RaisedButton(
                child: Text(
                  "Scheduled",
                ),
                onPressed: () {
                  notificationScheduled();
                },
              )
            ],
          )
      ),
    );
  }

  Future notificationDefaultSound() async{

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();

    var platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    flutterNotificationPlugin.show(
        0,
        'New Alert',
        'How to show Local Notification',
        platformChannelSpecifics,
        payload: 'Default Sound'
    );
  }

  Future notificationNoSound() async {

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(
        presentSound: false
    );

    var platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    flutterNotificationPlugin.show(
        0,
        'New Alert',
        'How to show Local Notification',
        platformChannelSpecifics,
        payload: 'No Sound'
    );

  }

  Future<void> notificationCustomSound() async{

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      // sound: 'slow_spring_board',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(
        sound: 'slow_spring_board.aiff'
    );

    var platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    flutterNotificationPlugin.show(
        0,
        'New Alert',
        'How to show Local Notification',
        platformChannelSpecifics,
        payload: 'Custom Sound'
    );

  }

  Future<void> notificationScheduled() async {
    int hour = 19;
    var ogValue = hour;
    int minute = 05;

    var time = Time(hour,minute,20);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.max,
      // sound: 'slow_spring_board',
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterNotificationPlugin.showDailyAtTime(4, 'show daily title',
      'Daily notification shown',time, platformChannelSpecifics,payload: "Hello",);

    print('Set at '+time.minute.toString()+" +"+time.hour.toString());

  }
}
*/
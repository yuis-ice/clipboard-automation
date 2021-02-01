import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:developer';  //(auto import will do this even)
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import 'package:sensors/sensors.dart';
import 'package:noise_meter/noise_meter.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

import 'package:clipboard/clipboard.dart';

// import 'package:downloads_path_provider/downloads_path_provider.dart';  
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:open_file/open_file.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

// var hoge = "dddddss";
String hoge = "This is hoge.";
String text = "Clipboard texts will be shown here...";
var channel;
bool ws_connected = false;
bool ws_connected_once = false;
var message;
int _selectedIndex = 0;
bool vibration_enabled = true;
bool copy_enabled = true;
bool open_file_enabled = false;
// Directory appDocDir;
// String appDocPath;

void main() async {
  runApp(MyApp());
  
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  // String appDocPath = appDocDir.path; // /data/user/0/com.example.flutter_application_2/app_flutter
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipboard Automation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Clipboard Automation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ((){           
            if ( _selectedIndex == 2 ) return <Widget>[
              // Text(
              //   'Here is about...',
              // ),
              Html(
                data: """
                  <div>
                    <h1>Clipboard Automation</h1>
                    <p>The app is a cross platform one-way clipboard control application for Android and iOS phones, made with Flutter. Compatible with Windows 10, Linux, OSX.</p>
                    <p>Please star this project on Github <a href="https://github.com/yuis-ice/">tmp</a>
                    <h2>Basic Usage</h2>
                    <p>This app cannot work as a standalone, you'll need node.js client instructed here <a href="https://github.com/yuis-ice/">tmp</a></p>
                    <h2>Developer</h2>
                    <p><a href="https://github.com/yuis-ice/">https://github.com/yuis-ice/</a> / yuis.twitter@gmail.com / Buy me a coffee <a href="https://github.com/yuis-ice/">tmp</a></p>
                  </div>
                """,
                onLinkTap: (url) async {
                  if (await canLaunch(url)) await launch(url) ;
                },
              )
              // Text(
              //   _selectedIndex.toString()
              // ),

            ];             
            if ( _selectedIndex == 1 ) return <Widget>[
              CheckboxListTile(
                title: Text("vibration enabled?"),
                // value: true,
                value: vibration_enabled,
                onChanged: (newValue) {
                  setState(() {
                    // vibration_enabled = false;
                    vibration_enabled = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: Text("copy enabled?"),
                // value: true,
                value: copy_enabled,
                onChanged: (newValue) {
                  setState(() {
                    copy_enabled = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: Text("open file enabled?"),
                // value: true,
                value: open_file_enabled,
                onChanged: (newValue) {
                  setState(() {
                    open_file_enabled = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              // TextField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Password',
              //   ),
              // ), // [TextField class - material library - Dart API](https://api.flutter.dev/flutter/material/TextField-class.html)
              // Text(
              //   vibration_enabled.toString()
              // )
            ];
            if ( _selectedIndex == 0 ) return <Widget>[
              Text(
                // 'tmp.',
                // hoge 
                text
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                tooltip: 'Start server',
                onPressed: () async {
                  // if (await (Connectivity().checkConnectivity()) == ConnectivityResult.wifi) debugPrint("you're on wifi network.");
                  // Vibration.vibrate();

                  // const url = 'https://google.com';
                  // if (await canLaunch(url)) await launch(url) ;


                  if ( ! ws_connected ) {

                    // var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.0.110:4444'));
                    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.0.110:4444'));
                    ws_connected = true;
                    ws_connected_once = true;
                    channel.stream.listen((message) async {
                      channel.sink.add('received!'); // instead, pass json and see that on the server side 
                      // channel.sink.close(status.goingAway); // to close. 
                      var obj = json.decode(message);

                      if (obj["type"] == "log") print(obj);
                      if (obj["type"] == "clipboard") if ( obj["clipboard"]["changed"] == true ) { 
                        text = obj["clipboard"]["text"];
                        setState(() {
                          text;
                        });
                        
                        print(text);

                        if ( copy_enabled ) await FlutterClipboard.copy(text);
                        // Vibration.vibrate();
                        if ( vibration_enabled ) Vibration.vibrate();
                        if ( open_file_enabled ) {
                          String filepath = (await getApplicationDocumentsDirectory()).path + '/' + 'tmp.html';
                          File(await filepath).writeAsString(text);
                          OpenFile.open(filepath);
                          // print("y.");
                        }
                        // print( vibration_enabled.toString() );
                      }
                    });
                    
                    setState(() {
                      message = {
                        "type": "info",
                        "message": "Channel started."
                      };
                    });
                    
                  } else {
                    setState(() {
                      message = {
                        "type": "error",
                        "message": "You have already one channel instance."
                      };
                    });
                  }

                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                tooltip: 'Stop server',
                onPressed: () async {
                  
                  if ( ws_connected_once == true ){
                    if ( ws_connected == true ){
                      channel.sink.close(status.goingAway);
                      ws_connected = false;
                      // print(channel.closeCode);
                      setState(() {
                        message = {
                          "type": "info",
                          "message": "Channel closed."
                        };
                      });
                    } else {
                      setState(() {
                        message = {
                          "type": "error",
                          "message": "No channel is being connected."
                        };
                      });
                    }
                  } else {
                    setState(() {
                      message = {
                        "type": "error",
                        "message": "You cannot close a channel that doesn't exist. You'll need to start a channel first."
                      };
                    });                  
                  }
                },
              ),
              Text(
                ((){
                  if ( message != null ) return message["message"];
                  if ( message == null ) return "Nothing to tell you for now...";
                }()),
                style: ((){
                  if ( message != null ) if ( message["type"] == "info" ){
                    return TextStyle(color: Colors.black.withOpacity(1.0));
                  }
                  if ( message != null ) if ( message["type"] == "error" ){
                    return TextStyle(fontWeight: FontWeight.bold, color: Colors.red.withOpacity(1.0));
                  }
                }())
              ),
              IconButton(
                icon: Icon(Icons.file_present),
                tooltip: 'Open file with app',
                onPressed: () async {
                  
                  String filepath = (await getApplicationDocumentsDirectory()).path + '/' + 'tmp.html';
                  File(await filepath).writeAsString(text);
                  OpenFile.open(filepath);

                },
              ),
            ];
          }())
        ),
      ),      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        }        
      ),      
    );
  }
}

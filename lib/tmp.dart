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

int _selectedIndex = 0;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
            if ( _selectedIndex == 0 ) return <Widget>[
              Text(
                'Index 0: Home',
              ),
              Text(
                _selectedIndex.toString()
              ),
            ];
            if ( _selectedIndex == 1 ) return <Widget>[
              Text(
                'Index 1: Business',
              ),
              Text(
                _selectedIndex.toString()
              ),
            ];
            if ( _selectedIndex == 2 ) return <Widget>[
              Text(
                'Index 2: School',
              ),
              Text(
                _selectedIndex.toString()
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
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
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

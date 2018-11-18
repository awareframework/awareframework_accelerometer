import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_accelerometer/awareframework_accelerometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AccelerometerSensor sensor;
  AccelerometerSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = AccelerometerSensorConfig()
      ..debug = true
      ..label = "label"
      ..interval = 30;

    sensor = new AccelerometerSensor(config);

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new AccelerometerCard(sensor: sensor,)
      ),
    );
  }
}

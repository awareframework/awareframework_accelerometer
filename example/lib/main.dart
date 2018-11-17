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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const MethodChannel _accelerometerMethod = const MethodChannel('awareframework_accelerometer/method');
    const EventChannel  _accelerometerStream  = const EventChannel('awareframework_accelerometer/event');
    var sensor = new AccelerometerSensor();

    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new AccelerometerCard(sensor: sensor, config: AwareSensorConfig(),)
      ),
    );
  }
}

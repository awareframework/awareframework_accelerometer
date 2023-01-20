import 'package:flutter/material.dart';

import 'package:awareframework_accelerometer/awareframework_accelerometer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AccelerometerSensor sensor;
  AccelerometerSensorConfig config;

  bool sensorState = true;

  var data = AccelerometerData();

  @override
  void initState() {
    super.initState();

    config = AccelerometerSensorConfig()
      ..debug = true
      ..label = "label"
      ..frequency = 100;

    // init sensor without a context-card
    sensor = new AccelerometerSensor.init(config);
    sensor.start();
    sensor.onDataChanged.listen((data) {
      print(data);
      setState(() {
        this.data = data;
      });
    });

    // card = new AccelerometerCard(sensor: sensor,);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: Text("${data.x} ${data.y} ${data.z}")),
    );
  }
}

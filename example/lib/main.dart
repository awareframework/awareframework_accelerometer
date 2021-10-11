import 'package:flutter/material.dart';

import 'package:awareframework_accelerometer/awareframework_accelerometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  late AccelerometerSensor sensor;
  AccelerometerData data = AccelerometerData();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool sensorState = true;

  @override
  void initState() {
    super.initState();

    var config = AccelerometerSensorConfig()
      ..debug = true
      ..label = "label"
      ..frequency = 1;

    // // init sensor without a context-card
    widget.sensor = new AccelerometerSensor.init(config);
    widget.sensor.start();
    widget.sensor.onDataChanged.listen((data) {
      setState(() {
        widget.data = data;
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
        body: Column(
          children: [
            Text("X: ${widget.data.x}"),
            Text("Y: ${widget.data.y}"),
            Text("Z: ${widget.data.z}"),
          ],
        ),
      ),
    );
  }
}

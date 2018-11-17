import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class AccelerometerSensor extends AwareSensorCore {
  static const MethodChannel _accelerometerMethod = const MethodChannel('awareframework_accelerometer/method');
  static const EventChannel  _accelerometerStream  = const EventChannel('awareframework_accelerometer/event');

  AccelerometerSensor():this.convenience();
  AccelerometerSensor.convenience(){
    super.setSensorChannels(_accelerometerMethod, _accelerometerStream);
  }

  // AccelerometerSensor.channel(MethodChannel _sampleMethod, EventChannel _sampleStream) : super.channel(_sampleMethod, _sampleStream);

/// overwrite methos and config classes.
/// ...

  Stream<Map<String,dynamic>> onDataChanged() {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

}

/// Make an AwareWidget
class AccelerometerCard extends StatefulWidget {
  AccelerometerCard({Key key, @required this.sensor, this.config}) : super(key: key);

  AccelerometerSensor sensor;
  AwareSensorConfig config;

  @override
  AccelerometerCardState createState() => new AccelerometerCardState();
}


class AccelerometerCardState extends State<AccelerometerCard> {
  var data = "";
  @override
  void initState() {
    super.initState();
    // init sensor
    if (widget.sensor == null) {
      widget.sensor = new AccelerometerSensor();
    }
    // init config
    if(widget.config == null){
      widget.config = AwareSensorConfig();
    }
    // set observer
    widget.sensor.onDataChanged().listen((event) {
      var _result = event;
      setState((){
        if(_result!=null){
          data = "x:${_result['x']}\ny:${_result['y']}\nz:${_result['z']}\n";
        }
      });
    }, onError: (dynamic error) {
      // print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    return new AwareCard(
      contentWidget: Text(data),
      title: "Sample",
      sensor: widget.sensor,
      sensorConfig: widget.config,
    );
  }
}

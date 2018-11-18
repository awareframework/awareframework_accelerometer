import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class AccelerometerSensor extends AwareSensorCore {
  static const MethodChannel _accelerometerMethod = const MethodChannel('awareframework_accelerometer/method');
  static const EventChannel  _accelerometerStream  = const EventChannel('awareframework_accelerometer/event');

  /// Init Accelerometer Sensor with AccelerometerSensorConfig
  AccelerometerSensor(AccelerometerSensorConfig config):this.convenience(config);
  AccelerometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_accelerometerMethod, _accelerometerStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class AccelerometerSensorConfig extends AwareSensorConfig{
  int interval = 5;
  double period = 1.0;
  double threshold = 0.0;

  AccelerometerSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['interval'] = interval;
    map['period'] =   period;
    map['threshold'] = threshold;
    return map;
  }
}


/// Make an AwareWidget
class AccelerometerCard extends StatefulWidget {
  AccelerometerCard({Key key, @required this.sensor}) : super(key: key);

  AccelerometerSensor sensor;

  @override
  AccelerometerCardState createState() => new AccelerometerCardState();
}


class AccelerometerCardState extends State<AccelerometerCard> {
  var data = "";
  @override
  void initState() {
    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          data = "x:${event['x']}\ny:${event['y']}\nz:${event['z']}\n";
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: Text(data),
      title: "Accelerometer",
      sensor: widget.sensor
    );
  }
}

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
    super.setMethodChannel(_accelerometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> onDataChanged(String id) {
     return super.getBroadcastStream( _accelerometerStream, "on_data_changed", id).map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class AccelerometerSensorConfig extends AwareSensorConfig{
  int frequency  = 5;
  double period = 1.0;
  double threshold = 0.0;

  AccelerometerSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period'] =   period;
    map['threshold'] = threshold;
    return map;
  }
}

/// Make an AwareWidget
class AccelerometerCard extends StatefulWidget {
  AccelerometerCard({Key key, @required this.sensor, this.bufferSize = 299, this.hight = 200.0}) : super(key: key);

  AccelerometerSensor sensor;
  int bufferSize;
  double hight;
  StreamSubscription<Map<String, dynamic>> handler;

  @override
  AccelerometerCardState createState() => new AccelerometerCardState();
}


class AccelerometerCardState extends State<AccelerometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  void initState() {
    super.initState();
    // set observer
    widget.handler = widget.sensor.onDataChanged("ui").listen((event) {
      if (mounted) {
        setState((){
          if(event!=null){
            StreamLineSeriesChart.add(data:event['x'], into:dataLine1, id:"x", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event['y'], into:dataLine2, id:"y", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event['z'], into:dataLine3, id:"z", buffer: widget.bufferSize);
          }
        });
      }
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    // print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return
      new AwareCard(
      contentWidget: SizedBox(
          height: widget.hight,
          width: MediaQuery.of(context).size.width * 0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Accelerometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelBroadcastStream("ui");
    super.dispose();
  }

}

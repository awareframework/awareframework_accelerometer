import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


///
/// The Accelerometer Sensor class
///
class AccelerometerSensor extends AwareSensorCore {

  /// Accelerometer Method Channel
  static const MethodChannel _accelerometerMethod = const MethodChannel('awareframework_accelerometer/method');

  /// Accelerometer Event Channel
  static const EventChannel  _accelerometerStream  = const EventChannel('awareframework_accelerometer/event');

  /// Init Accelerometer Sensor with AccelerometerSensorConfig
  AccelerometerSensor(AccelerometerSensorConfig config):this.convenience(config);
  AccelerometerSensor.convenience(config) : super(config){
    super.setMethodChannel(_accelerometerMethod);
  }

  Stream<Map<String,dynamic>> get onDataChanged {
     return super.getBroadcastStream( _accelerometerStream, "on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }

}

///
/// The Sensor Configuration Parameter class
///
class AccelerometerSensorConfig extends AwareSensorConfig {

  int frequency    = 5;
  double period    = 1.0;
  double threshold = 0.0;

  AccelerometerSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period']    = period;
    map['threshold'] = threshold;
    return map;
  }
}


////////////////////////////////////////////////////

///
/// The Accelerometer Card Class
///
class AccelerometerCard extends StatefulWidget { // ignore: must_be_immutable
  AccelerometerCard({Key key, this.sensor,
                              this.bufferSize = 299,
                              this.height = 200.0}) : super(key: key);
  final int    bufferSize;
  final double height;
  final AccelerometerSensor sensor;

  final List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine3 = List<LineSeriesData>();

//  @override
//  AccelerometerCardState createState() {
//    cardState = new AccelerometerCardState();
//    return cardState;
//  }

  @override
  AccelerometerCardState createState() => new AccelerometerCardState();

}


class AccelerometerCardState extends State<AccelerometerCard> {

  @override
  void initState() {
    super.initState();

    widget.sensor.onDataChanged.listen((event) {
      if (mounted) {
        setState((){
          if(event!=null){
            StreamLineSeriesChart.add(data:event['x'], into:widget.dataLine1, id:"x", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event['y'], into:widget.dataLine2, id:"y", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event['z'], into:widget.dataLine3, id:"z", buffer: widget.bufferSize);
          }
        });
      }
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  @override
  Widget build(BuildContext context) {
    var data = StreamLineSeriesChart.createTimeSeriesData(widget.dataLine1, widget.dataLine2, widget.dataLine3);
    return
      new AwareCard(
      contentWidget: SizedBox(
          height: widget.height,
          width: MediaQuery.of(context).size.width * 0.8,
          child: new StreamLineSeriesChart(data),
        ),
      title: "Accelerometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

/// The accelerometer measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = AccelerometerSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  AccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = AccelerometerSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<AccelerometerData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = AccelerometerCard(sensor: sensor);
/// ```
class AccelerometerSensor extends AwareSensor {
  /// Accelerometer Method Channel
  static const MethodChannel _accelerometerMethod =
      const MethodChannel('awareframework_accelerometer/method');

  /// Accelerometer Event Channel
  // static const EventChannel  _accelerometerStream = const EventChannel('awareframework_accelerometer/event');

  static const EventChannel _onDataChangedStream =
      const EventChannel('awareframework_accelerometer/event_on_data_changed');

  static AccelerometerData data = AccelerometerData();

  static StreamController<AccelerometerData> streamController =
      StreamController<AccelerometerData>();

  /// Init Accelerometer Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = AccelerometerSensor.init(null);
  /// ```
  AccelerometerSensor() : super(null);

  /// Init Accelerometer Sensor with AccelerometerSensorConfig
  ///
  /// ```dart
  /// var config =  AccelerometerSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = AccelerometerSensor.init(config);
  /// ```
  AccelerometerSensor.init(AccelerometerSensorConfig config) : super(config) {
    super.setMethodChannel(_accelerometerMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<AccelerometerData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  /// [Creating Streams](https://www.dartlang.org/articles/libraries/creating-streams)
  Stream<AccelerometerData> get onDataChanged {
    streamController.close();
    streamController = StreamController<AccelerometerData>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    // listen data update on sensor itself
    super
        .getBroadcastStream(_onDataChangedStream, "on_data_changed")
        .map((dynamic event) =>
            AccelerometerData.from(Map<String, dynamic>.from(event)))
        .listen((event) {
      data = event;
      if (!streamController.isClosed) {
        streamController.add(data);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }
}

/// A configuration class of AccelerometerSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  AccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class AccelerometerSensorConfig extends AwareSensorConfig {
  /// Data samples to collect per second (Hz). (default = 5)
  int frequency = 5;

  /// Period to save data in minutes. (default = 1.0)
  double period = 1.0;

  /// If set, do not record consecutive points if change in value is less than
  /// the set value.
  double threshold = 0.0;

  AccelerometerSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period'] = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// A data model of AccelerometerSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class AccelerometerData extends AwareData {
  double x = 0.0;

  double y = 0.0;

  double z = 0.0;

  AccelerometerData() : this.from({});

  AccelerometerData.from(Map<String, dynamic>? data) : super(data ?? {}) {
    if (data != null) {
      x = data["x"] ?? 0.0;
      y = data["y"] ?? 0.0;
      z = data["z"] ?? 0.0;
    }
  }
}

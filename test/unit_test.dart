import 'package:test/test.dart';
import 'package:awareframework_accelerometer/awareframework_accelerometer.dart';

void main(){
  test("test sensor config", (){
    var config = AccelerometerSensorConfig();
    expect(config.deviceId, "");
    expect(config.debug, false);
    expect(config.frequency, 5);
    expect(config.period, 1.0);
    expect(config.threshold, 0.0);
  });
}
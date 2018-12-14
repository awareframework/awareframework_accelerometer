import Flutter
import UIKit
import com_awareframework_ios_sensor_accelerometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkAccelerometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, AccelerometerObserver{
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.accelerometerSensor = AccelerometerSensor.init(AccelerometerSensor.Config(config))
            }else{
                self.accelerometerSensor = AccelerometerSensor.init(AccelerometerSensor.Config())
            }
            self.accelerometerSensor?.CONFIG.sensorObserver = self
            return self.accelerometerSensor
        }else{
            return nil
        }
    }
    
    var accelerometerSensor:AccelerometerSensor?
    
    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkAccelerometerPlugin()
        // add own channel
        super.setMethodChannel(with: registrar,
                               instance: instance,
                               channelName: "awareframework_accelerometer/method");
        super.setEventChannels(with: registrar,
                               instance: instance,
                               channelNames: ["awareframework_accelerometer/event",
                                              "awareframework_accelerometer/event_on_data_changed"]);

    }

    public func onDataChanged(data: AccelerometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}

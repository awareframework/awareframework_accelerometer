import Flutter
import UIKit
import com_aware_ios_sensor_accelerometer
import com_aware_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkAccelerometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorStartCallHandler, AccelerometerObserver{

    public override init() {
        super.init()
        self.startCallEventHandler = self
    }
    
    var accelerometerSensor:AccelerometerSensor?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkAccelerometerPlugin(),
                          methodChannelName: "awareframework_accelerometer/method",
                          eventChannelName: "awareframework_accelerometer/event")
    }
    
    public func start(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            self.accelerometerSensor = AccelerometerSensor.init(AccelerometerSensor.Config())
            self.accelerometerSensor?.CONFIG.sensorObserver = self
            self.accelerometerSensor?.start()
            return self.accelerometerSensor
        }else{
            return nil
        }
        
    }
    
    public func onDataChanged(data: AccelerometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}

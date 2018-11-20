import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_accelerometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkAccelerometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, AccelerometerObserver{
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.accelerometerSensor = AccelerometerSensor.init(AccelerometerSensor.Config(json))
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
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkAccelerometerPlugin(),
                          methodChannelName: "awareframework_accelerometer/method",
                          eventChannelName: "awareframework_accelerometer/event")

    }
    

    public func onDataChanged(data: AccelerometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}

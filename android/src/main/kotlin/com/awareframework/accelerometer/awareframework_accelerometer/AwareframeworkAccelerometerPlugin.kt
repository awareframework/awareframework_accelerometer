package com.awareframework.accelerometer.awareframework_accelerometer

import android.content.Intent
import android.os.Handler
import com.awareframework.android.core.db.Engine
import com.awareframework.android.sensor.accelerometer.model.AccelerometerData
import com.awareframework.android.sensor.accelerometer.AccelerometerSensor

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

import android.util.Log
import android.os.Looper
import com.awareframework.android.core.AwareSensor
import io.flutter.plugin.common.EventChannel.EventSink

/** AwareframeworkAccelerometerPlugin */

class AwareframeworkAccelerometerPlugin: AwareFlutterPluginCore(), FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.setMethodChannel(flutterPluginBinding, this, "awareframework_accelerometer/method")
    this.setEventChannels(flutterPluginBinding, this, listOf("awareframework_accelerometer/event",
      "awareframework_accelerometer/event_on_data_changed"))
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.resetMethodChannel()
    this.resetEventChannels()
  }

}

/// A protocol for handling a sensor initialization call
///
/// This method is called when Flutter executes `-start()` method on AwareSensor and if AwareSensor instance is null.
//interface AwareFlutterPluginSensorInitializationHandler {
//    fun initializeSensor(call: MethodCall, result: Result): AwareSensor?
//}

/// A protocol for handling method calls
///
/// This methods are called when begin and end of a method handle event.
/// By using this protocol, you can add any operation before and after the event.
interface AwareFlutterPluginMethodHandler{
  fun beginMethodHandle(call: MethodCall, result: Result)
  fun endMethodHandle(call: MethodCall, result: Result)
}


open class AwareFlutterPluginCore: StreamHandler, MethodCallHandler {

  /// An AwareSensor instance
  /// - note
  /// For handling method calls inside `AwareFlutterPluginCore`, this instance should be initialized when this class is initialized or `-initializeSensor(:result:)` is called initialization method is called.
  // public var sensor:AwareSensor? = null

//  var sensorController:ISensorController? = null

  /// Stream channel handlers
  var streamHandlers: ArrayList<MyStreamHandler> = ArrayList()

  /// A delegate of initialization call event
  // public var initializationCallEventHandler:AwareFlutterPluginSensorInitializationHandler? = null

  /// A delegate of method events
  var methodEventHandler:AwareFlutterPluginMethodHandler? = null

  var methodChannel : MethodChannel? = null
  var eventChannels = ArrayList<EventChannel>()

  var binding:FlutterPlugin.FlutterPluginBinding? = null
  /// Set a method channel
  ///
  /// - Parameters:
  ///   - registrar: A helper providing application context and methods for registering callbacks.
  ///   - instance: The receiving object, such as the plugin's main class
  ///   - channelName: A channel name of this method channel
  public fun setMethodChannel(binding: FlutterPlugin.FlutterPluginBinding,
                              instance:MethodCallHandler,
                              channelName:String) {
    this.binding = binding
    this.methodChannel = MethodChannel(binding.binaryMessenger, channelName)
    this.methodChannel?.setMethodCallHandler(instance)
  }


  /// Set event (stream) channels
  ///
  /// - Parameters:
  ///   - registrar: A helper providing application context and methods for registering callbacks.
  ///   - instance: The receiving object, such as the plugin's main class
  ///   - channelNames: The names of event channels
  public fun setEventChannels(binding: FlutterPlugin.FlutterPluginBinding,
                              instance:StreamHandler,
                              channelNames:List<String>){
    this.binding = binding
    for (name in channelNames) {
      val stream = EventChannel(binding.binaryMessenger, name)
      stream.setStreamHandler(instance)
      eventChannels.add(stream)
    }
  }

  public fun resetMethodChannel(){
    this.methodChannel?.setMethodCallHandler(null)
    this.methodChannel = null
  }

  public fun resetEventChannels(){
    this.eventChannels.forEach {
      it.setStreamHandler(null)
    }
    this.eventChannels.clear()
  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    this.methodEventHandler?.beginMethodHandle(call, result)

    Log.d(this.toString(), call.method)

    when (call.method) {
      "start" -> {
        this.start(call, result)
      }
      "sync" -> {
        this.sync(call, result)
      }
      "stop" -> {
        this.stop(call, result)
      }
      "enable" -> {
        this.enable(call, result)
      }
      "disable" -> {
        this.disable(call, result)
      }
      "is_enable" -> {
        this.isEnable(call, result)
      }
      "cancel_broadcast_stream" -> {
        this.cancelStreamHandler(call, result)
      }
      "set_label" -> {
        this.setLabel(call, result)
      }
      else -> {
        result.notImplemented()
      }
    }

    this.methodEventHandler?.endMethodHandle(call, result)
  }


  open fun start(call: MethodCall, result: Result) {
    //    sensorController?.start()
    // To start the service.
    this.binding?.applicationContext?.let { appContext ->
      val config = AccelerometerSensor.Config()
      val args = call.arguments
      if (args is Map<*,*>){

        val interval = args["interval"]
        val period = args["period"]
        var threshold = args["threshold"]
        val debug = args["debug"]
        val deviceId = args["deviceId"]
        val dbEncryptionKey = args["dbEncryptionKey"]
        val dbHost = args["dbHost"]

        if (interval is Int) config.interval = interval
        if (period is Float) config.period = period
        if (threshold is Double) config.threshold = threshold
        if (debug is Boolean) config.debug = debug
        if (deviceId is String) config.deviceId = deviceId
        if (dbEncryptionKey is String) config.dbEncryptionKey = dbEncryptionKey
        if (dbHost is String) config.dbHost = dbHost
      }

      AccelerometerSensor.start(appContext, config.apply {
        sensorObserver = object : AccelerometerSensor.Observer {

          override fun onDataChanged(data: AccelerometerData) {
            for( handler in streamHandlers) {
              handler.eventSink?.let {
                val d = mapOf<String, Any>("x" to data.x, "y" to data.y, "z" to data.z,
                  "accuracy" to data.accuracy, "timezone" to data.timezone,
                  "eventTimestamp" to data.eventTimestamp, "timestamp" to data.timestamp);
                it.success(d)
              }
            }
          }

        }
        dbType = Engine.DatabaseType.ROOM
        debug = true
      })
    }

  }

  open fun stop(call: MethodCall, result: Result) {
    this.binding?.applicationContext?.let { appContext ->
      AccelerometerSensor.stop(appContext)
    }
  }

  open fun sync(call: MethodCall, result: Result) {
    if (call.arguments != null) {
      call.arguments.let { args ->
        if (args is Map<*, *>) args["force"].let { state ->
          if (state is Boolean) {
            val intent = Intent(AccelerometerSensor.ACTION_AWARE_ACCELEROMETER_SYNC)
            binding?.applicationContext?.sendBroadcast(intent)
            return
          }
        }
      }
    }
//    sensorController?.sync(false)
  }

  open fun enable(call: MethodCall, result: Result) {
//    sensorController?.enable()
  }

  open fun disable(call: MethodCall, result: Result) {
//    sensorController?.disable()
  }

  open fun isEnable(call: MethodCall, result: Result) {
//    if (sensorController != null) {
//      result.success(sensorController?.isEnabled())
//    }
  }

  open fun setLabel(call: MethodCall, result: Result) {

  }

  public fun cancelStreamHandler(call: MethodCall, result: Result) {
    call.arguments.let { args ->
      when(args) {
        is Map<*, *> -> {
          when(val eventName = args["name"]){
            is String -> removeDuplicateEventNames(eventName)
            else -> {}
          }
        }
        else -> {}
      }
    }
  }


  private fun removeDuplicateEventNames(eventName:String){
    val events = ArrayList<MyStreamHandler>()
    this.streamHandlers.forEach { myStreamHandler ->
      if (myStreamHandler.eventName == eventName) {
        Log.d("[NOTE]",
          "($eventName) is duplicate. The current event channel is overwritten by the new event channel."
        )
        events.add(myStreamHandler)
      }
    }
    this.streamHandlers.removeAll(events)
  }

  public fun getStreamHandlers(name: String): List<MyStreamHandler>? {
    this.getStreamHandler(name)?.let {
      return mutableListOf(it)
    }
    return null
  }

  private fun getStreamHandler(name: String):MyStreamHandler? {
    for (handler in this.streamHandlers){
      if (handler.eventName == name) {
        return handler
      }
    }
    return null
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    arguments?.let { args ->
      when (args) {
        is Map<*, *> -> {
          when (val eventName = args["name"]) {
            is String -> {
              this.removeDuplicateEventNames(eventName)
              events?.let {
                val handler = MyStreamHandler(eventName, MainThreadEventSink(events))
                streamHandlers.add(handler)
              }
            }
            else -> {}
          }
        }
        else -> {}
      }
    }
  }

  override fun onCancel(arguments: Any?) {

  }

}


class MyStreamHandler(val eventName: String, var eventSink: MainThreadEventSink?){}


class MainThreadEventSink internal constructor(private val eventSink: EventSink) :
  EventSink {
  private val handler: Handler = Handler(Looper.getMainLooper())

  override fun success(o: Any) {
    handler.post(Runnable { eventSink.success(o) })
  }

  override fun error(s: String, s1: String, o: Any) {
    handler.post(Runnable { eventSink.error(s, s1, o) })
  }

  override fun endOfStream() {
  }

}
//class AwareframeworkAccelerometerPlugin: FlutterPlugin, MethodCallHandler {
//  /// The MethodChannel that will the communication between Flutter and native Android
//  ///
//  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//  /// when the Flutter Engine is detached from the Activity
//  private lateinit var channel : MethodChannel
//
//  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "awareframework_accelerometer")
//    channel.setMethodCallHandler(this)
//  }
//
//  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//    if (call.method == "getPlatformVersion") {
//      result.success("Android ${android.os.Build.VERSION.RELEASE}")
//    } else {
//      result.notImplemented()
//    }
//  }
//
//  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//    channel.setMethodCallHandler(null)
//  }
//}
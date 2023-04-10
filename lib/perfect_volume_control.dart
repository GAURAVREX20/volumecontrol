import 'dart:async';

import 'package:flutter/services.dart';

class PerfectVolumeControl {
  static const MethodChannel _channel =
      const MethodChannel('perfect_volume_control');

  /// 音量改变监听器流
  /// Volume change monitor flow
  static StreamController<double> _streamController =
      StreamController.broadcast();

  /// 音量改变监听器名称
  /// Volume change monitor name
  static const String _volumeChangeListenerName = "volumeChangeListener";


  static Future<dynamic> _methodCallHandler(call) async {
    if (call.method == _volumeChangeListenerName) {
      double volume = call.arguments;
      _streamController.add(volume);
    }
  }


  static Stream<double> get stream {
    _channel.setMethodCallHandler(_methodCallHandler);
    return _streamController.stream;
  }


  static set hideUI(bool hide) {
    _channel.invokeMethod('hideUI', {"hide": hide});
  }


  static Future<double> get volume => getVolume();


  static Future<double> getVolume() async {
    return await _channel.invokeMethod('getVolume');
  }


  static Future<void> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    return await _channel.invokeMethod('setVolume', {"volume": volume});
  }
}

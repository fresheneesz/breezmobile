import 'package:flutter/services.dart';

class Permissions {
  static const MethodChannel channel =
  const MethodChannel('com.breez.client/permissions');

  Future<bool> isInOptimizationWhitelist(){
    return channel.invokeMethod("isInOptimizationWhitelist").then((res) => res as bool);
  }

  Future<bool> requestOptimizationSettings() {    
    return channel.invokeMethod('requestOptimizationSettings').then( (res) => res as bool);
  }

  Future<bool> requestOptimizationWhitelist() {    
    return channel.invokeMethod('requestOptimizationWhitelist').then( (res) => res as bool);
  }
}

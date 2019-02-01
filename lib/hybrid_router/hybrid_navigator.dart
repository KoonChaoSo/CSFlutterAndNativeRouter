import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> MethodHandler(MethodCall call);

class HybridNavigatorForFlutter {
  static HybridNavigatorForFlutter hybridNavigatorForFlutter =
      new HybridNavigatorForFlutter._internal();
  MethodChannel _channel;
  MethodHandler _handler;
  void setMethodCallHandler(MethodHandler hdler) {
    _handler = hdler;
    _channel.setMethodCallHandler(_handler);
  }

  HybridNavigatorForFlutter._internal() {
    _channel = new MethodChannel('cs_hybrid_router');    
  }
  
  pushVcWithUrlForNative({String name,Map params,bool animated}) {
    _channel.invokeMethod("pushVcWithUrlForNative", {
      "name": name ?? "",
      "params": (params ?? {}),
      "animated": animated ?? false
    });
  }

  popCurPage({bool animated = true}) {
    _channel.invokeMethod("popVc", animated);
  }

  updateCurFlutterRoute(String curRouteName) {
    print("updateCurFlutterRoute ==== $curRouteName");
    _channel.invokeMethod("setFlutterVcName", curRouteName ?? "");
  }
}
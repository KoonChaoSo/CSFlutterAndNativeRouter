import 'package:flutter/material.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/router.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/routes_map.dart';
import 'package:cs_flutter_and_native_router/my_app.dart';

import 'fdemo.dart';

class AppConfig {
  static final AppConfig _singleton = new AppConfig._internal();
  static final GlobalKey gHomeItemPageWidgetKey =
      new GlobalKey(debugLabel: "[KWLM]");
  
  static AppConfig sharedInstance() {
    Router.sharedInstance.globalkey = gHomeItemPageWidgetKey;
    print('appconfig === ${gHomeItemPageWidgetKey.currentContext}');
    // Router.sharedInstance.routerWidgetHandler =
    //     ({RouterOption routeOption, Key key}) {
    //   if (routeOption.url == "hrd://fdemo") {
    //     return new FDemoWidget(routeOption, key: key);
    //   }
    //   return null;
    // };
    return _singleton;
  }

  AppConfig._internal() {
    RoutersMap.sharedInstance().registerRouter("Test1", new FDemoWidget());
  }
}

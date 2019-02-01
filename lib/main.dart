import 'package:flutter/material.dart';
import 'app_config.dart';
import 'hybrid_router/router.dart';
import 'hybrid_router/utils.dart';
import 'my_app.dart';

void main() async {
  AppConfig.sharedInstance();
  runApp(new MyApp());
  print("main() => pushVc ");
    RouterInfo info = RouterInfo(params: {},pageName: 'Test1');
    info.userInfo = Utils.getUniqueFlutterPageId('Test1');
    Router.sharedInstance.pushViewControllerForFlutterNamed(info,false);
}

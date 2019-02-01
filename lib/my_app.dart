import 'package:flutter/material.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/router.dart';

import 'app_config.dart';

class MyApp extends StatefulWidget {
  MyApp();
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("MyAppState === ${Router.singleton().globalkey}");
    ThemeData themeData = new ThemeData(
      primarySwatch: Colors.blue,
    );
    return new MaterialApp(
      title: '混合栈Demo',
      theme: themeData,
      home: new MyHomeWidget(key:Router.singleton().globalkey),
    );
  }
}

class MyHomeWidget extends StatefulWidget {
  
  MyHomeWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyHomeWidgetState();
  }
}

class MyHomeWidgetState extends State<MyHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
    );
  }
}

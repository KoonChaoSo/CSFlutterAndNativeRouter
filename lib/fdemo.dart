import 'package:flutter/material.dart';
import 'hybrid_router/hybrid_navigator.dart';
import 'hybrid_router/router.dart';
import 'hybrid_router/utils.dart';

class FDemoWidget extends StatelessWidget {
  RouterInfo routeOption;
  FDemoWidget({RouterInfo option, Key key}) : super(key: key) {
    routeOption = option;
  }
  Widget build(BuildContext context) {
    int pageId = Utils.getPageId();
    return new Scaffold(
        appBar: new AppBar(
          leading: new GestureDetector(
              child: new Icon(Icons.arrow_back),
              onTap: () {
                HybridNavigatorForFlutter.hybridNavigatorForFlutter.popCurPage();
              }),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text("Flutter Page($pageId)"),
        ),
        body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug paint" (press "p" in the console where you ran
            // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
            // window in IntelliJ) to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(width: 1.0, height: 100.0),
              new GestureDetector(
                child: new Text("Click to open FlutterPage"),
                onTap: () {
                  HybridNavigatorForFlutter.hybridNavigatorForFlutter
                      .pushVcWithUrlForNative(
                          name: "Test1", params: {"isFlutter": "isFlutter"});
                },
              ),
              new SizedBox(width: 1.0, height: 100.0),
              new GestureDetector(
                child: new Text("Click to open NativePage"),
                onTap: () {
                  HybridNavigatorForFlutter.hybridNavigatorForFlutter
                      .pushVcWithUrlForNative(
                          name: "Test1", params: {});
                },
              )
            ],
          ),
        ),
        floatingActionButton:
            null // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

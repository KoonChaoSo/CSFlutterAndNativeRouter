import 'package:flutter/material.dart';

class RoutersMap {
  Map<String, Widget> pageMap;
  static final RoutersMap _singleton = RoutersMap._internal();
  
  RoutersMap._internal()
  {    
    pageMap = new Map<String,Widget>();
  }

  static RoutersMap sharedInstance()
  {
    return _singleton;
  }
  
  registerRouter(String routerName,Widget page)
  {
    print('registerRouter ====== $page');
      pageMap[routerName] = page;
  }


}
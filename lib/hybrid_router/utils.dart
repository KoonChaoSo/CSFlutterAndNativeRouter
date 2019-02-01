import 'package:cs_flutter_and_native_router/hybrid_router/router.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/routes_map.dart';


class Utils extends Object {
  static int pageId = 100;
  static int getPageId()
  {
    return pageId;
  }

  static resetPageId()
  {
    pageId = 100;
  }
  
  static int plusPageId()
  {
    return pageId++;
  }
      
  static pageFromPageInfo(String pageKey)
  {
    return RoutersMap.sharedInstance().pageMap[pageKey];
  }

  static String getUniqueFlutterPageId(String pageKey)
  {      
      
      return (pageKey??"") + 
      "-" +  
      (plusPageId().toString());
  }
}
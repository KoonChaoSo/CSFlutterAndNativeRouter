import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/hybrid_navigator.dart';
import 'package:cs_flutter_and_native_router/hybrid_router/utils.dart';


class RouterInfo
{
  String url;
  String pageName;
  Map params;
  String userInfo;
  RouterInfo({this.url, this.pageName, this.params});
}

class CSMaterialPageRoute<T> extends MaterialPageRoute<T> {
  final WidgetBuilder builder;
  final bool animated;
  final GlobalKey boundaryKey;
  Duration get transitionDuration {
    if (animated == true) return const Duration(milliseconds: 300);
    return const Duration(milliseconds: 0);
  }

  CSMaterialPageRoute({
    this.builder,
    this.animated,
    this.boundaryKey,
    RouteSettings settings: const RouteSettings(),
  }) : super(builder: builder, settings: settings);
}

class Router extends Object{
  static final Router sharedInstance = Router._sharedInstand();
  GlobalKey globalkey;
  List navList = new List(); //记录跳转栈  因为闲鱼使用navHistory的方法已经过时了

  Router._sharedInstand(){
    HybridNavigatorForFlutter.hybridNavigatorForFlutter.setMethodCallHandler((MethodCall call){
      print("abcdefghijkkkkkkkkkk");
      if (call.method == "pushVcWithUrlForFlutter")
      {
          
          String pageName = call.arguments["pageName"];
          RouterInfo info = RouterInfo(url: "",pageName: pageName,params:{});
          info.userInfo = Utils.getUniqueFlutterPageId(pageName);                      
          Router.sharedInstance.pushViewControllerForFlutterNamed(info,false);  
      }
      else if (call.method == "popToRoot")
      {
        print('popToRoot ======');     
          bool animated = call.arguments["animated"];
          Router.sharedInstance.popToRouteViewController(false);
      }
      else if (call.method == "popViewControllerForFlutter")
      {
        print("popViewControllerForFlutter");
          // bool animated = call.arguments["animated"];
        Router.sharedInstance.popViewControllerForFlutter(globalkey.currentContext,false);
      }
      else if (call.method == 'popToVc')
      {        
          String pageId = call.arguments["pageName"];
          
          print('popToVc ====== $pageId');     
          Router.sharedInstance.popToPage(pageId, false);
      }
    });
  }

  static Router singleton() {
    return sharedInstance;
  }

  // pushViewControllerForFlutter(RouterInfo info,bool animated)
  // {
  //   //TODO:如果是Flutter页面就push过去
  //   //如果page没有的话就不应该跳转
  //   print("pushViewControllerForFlutter");
  //   Widget page = info.page;   
  //   print(page);
  //   // if (page != null)
  //   // {
  //   CSMaterialPageRoute pageRoute = new CSMaterialPageRoute(
  //     settings: new RouteSettings(name: "Test5"),
  //     animated: animated,
  //     builder: (BuildContext context) {
  //       return new MyApp();
  //     });
  //     print("pageRoute === $pageRoute");
  //     navList.add(pageRoute);
  //     print("navList === $navList");
  //     Navigator.of(routerGlobalKey.currentContext).pushReplacementNamed(routeName)
  //     // Navigator.of(routerGlobalKey.currentContext).pushReplacementNamed('Test5');
      
  //   // }
  // }

  pushViewControllerForFlutterNamed(RouterInfo router,bool animated)
  {
    //TODO:如果是Flutter页面就push过去
    //如果page没有的话就不应该跳转
    Widget page = Utils.pageFromPageInfo(router.pageName);
    print("pushViewControllerForFlutter == ${router.userInfo} and page == $page");
    if (router != null)
    {    
      CSMaterialPageRoute pageRoute = new CSMaterialPageRoute(
          settings: new RouteSettings(name: router.userInfo),
          animated: false,
          builder: (BuildContext context) {
            return new RepaintBoundary(child: page);
          });

        navList.add(pageRoute);
        BuildContext code = globalkey.currentContext;
        print("code == $code");
        print("navList === $navList");
        if (code != null)
        {
          print("navigator");
          Navigator.of(globalkey.currentContext).push(pageRoute);      
        }
        HybridNavigatorForFlutter.hybridNavigatorForFlutter.updateCurFlutterRoute(router.userInfo);
    }
  }

  pushViewControllerForNative(RouterInfo info,bool animated)
  {
      //通知原生跳转
      HybridNavigatorForFlutter.hybridNavigatorForFlutter.pushVcWithUrlForNative(name: info.pageName,params: {'pageName':info.pageName},animated: animated);
  }

  popViewControllerForFlutter(BuildContext context,bool animated)
  {
      //选择在navList上面的所有页面判断是否需要出栈
      print("navList === $navList");            
      Navigator.of(context).removeRoute(navList.last);
      navList.removeLast();
      print("after remove navList === $navList");
  }

  popToPage(String pageId,bool animated)
  {
    int histLen = navList.length;
    String routeName = pageId;
    print('popToPage ==== $routeName');
    for (int i = histLen - 1; i >= 1; i--) {
      Route route = navList.elementAt(i);
      if (!(route is CSMaterialPageRoute) ||
          ((route as CSMaterialPageRoute).settings.name != routeName)) {
        print('popTopage,Navigator ==== $route');
        Navigator.of(globalkey.currentContext).removeRoute(route);
        navList.remove(route);
      }
      if ((route is CSMaterialPageRoute) &&
          ((route as CSMaterialPageRoute).settings.name == routeName)) break;
    }
  }

  popToRouteViewController(bool animated)
  {
      //退出在栈上所有页面
      int histLen = navList.length;
      print("navList === $navList");
      for (int i = histLen - 1; i >= 1; i--) {
      Route route = navList.elementAt(i);
      if (!(route is CSMaterialPageRoute)) {
        print('popToRouteViewController,Navigator ==== $route');
        Navigator.of(globalkey.currentContext).removeRoute(route);
        navList.remove(route);
      }
    }

      //暴力置空
      print("navList2 === $navList");
      navList = new List();
  }

  // Router viewControllerFromInfo(RouterInfo info)
  // {
  //   // 从栈上查看是否有这个信息的页面
  // }


}


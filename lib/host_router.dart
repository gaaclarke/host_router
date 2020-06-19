import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'messages.dart';

class _MyFlutterRouterApi extends FlutterRouterApi {
  void Function(String name) pusher;
  void Function() popper;
  static _MyFlutterRouterApi _instance = null;
  static _MyFlutterRouterApi get instance {
    if (_instance == null) {
      _instance = _MyFlutterRouterApi();
      FlutterRouterApi.setup(_instance);
      print('setup happened');
    }
    return _instance;
  }

  void pushRoute(PushRoute arg) {
    print('got push route: ${arg.name}');
    pusher(arg.name);
  }
  
  void popRoute() {
    popper();
  }
}

class RouterNavigator {
  final HostRouterAppState router;
  final BuildContext context;

  RouterNavigator(this.router, this.context);
  
  static RouterNavigator of(BuildContext context) {
    HostRouterAppState router = context.findAncestorStateOfType<HostRouterAppState>();
    return RouterNavigator(router, context);
  }

  void push(String name) {
    router._push(context, name);
  }

  void pop() {
    router._pop(context);
  }
}

class RouterRoute {
  RouterRoute({@required RouteLocation location, Route Function(Object args) func}) : location = location, func = func {}
  final RouteLocation location;
  final Route Function(Object args) func;
}

typedef HostRouterAppBuilder = Widget Function(RouteFactory routeFactory);

class HostRouterApp extends StatefulWidget {
  HostRouterApp({@required Map<String, RouterRoute> routeMap, HostRouterAppBuilder appBuilder}) 
      : routeMap = routeMap,
        appBuilder =  appBuilder ?? _materialAppBuilder;

  final Widget Function(RouteFactory routeFactory) appBuilder;
  final Map<String, RouterRoute> routeMap;

  static Widget _materialAppBuilder(RouteFactory routerFactory) {
    return MaterialApp(onGenerateRoute: routerFactory);
  }

  @override
  HostRouterAppState createState() => HostRouterAppState();
}

class HostRouterAppState extends State<HostRouterApp> {
  final HostRouterApi _api = HostRouterApi();
  String _path = "";

  void _push(BuildContext context, String name) {
    PushRoute pushRouteMessage = PushRoute()..name = name;
    if (widget.routeMap[name].location == RouteLocation.flutter) {
      Navigator.of(context).pushNamed(name);
      _api.pushFlutterRoute(pushRouteMessage);
    } else {
      _api.pushHostRoute(pushRouteMessage);
    }
    _path = '$_path$name';
    print('path: $_path');
  }

  void _pop(BuildContext context) {
    List<String> components = _path.split('/');
    String top = '/${components.last}';
    String next = '/${components[components.length - 2]}';
    print('popping: $top to $next');
    if (widget.routeMap[top].location == RouteLocation.flutter) {
      if (widget.routeMap[next].location == RouteLocation.flutter) {
        Navigator.of(context).pop();
      } else {
        PopRoute popRouteMessage = PopRoute()..name = top;
        _api.popRoute(popRouteMessage);
      }
    } else {
      PopRoute popRouteMessage = PopRoute()..name = top;
      _api.popRoute(popRouteMessage);
    }
    components.removeLast();
    _path = components.join('/');
    print('path: $_path');
  }

  static Route _makeRoute(Map<String, RouterRoute> routes, RouteSettings settings) {
    return routes[settings.name].func(settings.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return widget.appBuilder((RouteSettings settings) {
      return _makeRoute(widget.routeMap, settings);
    });
  }
}

class RouterPage extends StatelessWidget {
  RouterPage(this.child);

  final Widget child;

  Future<bool> _onBackPressed(BuildContext context) {
    return new Future(() {
      RouterNavigator.of(context).pop();
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _MyFlutterRouterApi.instance.pusher = (String name) { RouterNavigator.of(context).push(name); };
    _MyFlutterRouterApi.instance.popper = () { RouterNavigator.of(context).pop(); };
    return WillPopScope(onWillPop: () => _onBackPressed(context), child: child);
  }
}

enum RouteLocation {
  host,
  flutter,
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'messages.dart';

class RouterNavigator {
  final HostRouterApp router;
  final BuildContext context;

  RouterNavigator(this.router, this.context);
  
  static RouterNavigator of(BuildContext context) {
    HostRouterApp router = context.findAncestorWidgetOfExactType<HostRouterApp>();
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

class HostRouterApp extends StatelessWidget {
  HostRouterApp({@required Map<String, RouterRoute> routeMap, HostRouterAppBuilder appBuilder}) 
      : routeMap = routeMap,
        _appBuilder =  appBuilder ?? _materialAppBuilder;

  final Widget Function(RouteFactory routeFactory) _appBuilder;
  final Map<String, RouterRoute> routeMap;
  final HostRouterApi _api = HostRouterApi();

  void _push(BuildContext context, String name) {
    if (routeMap[name].location == RouteLocation.flutter) {
      Navigator.of(context).pushNamed(name);
    } else {
      PushRoute pushRouteMessage = PushRoute()..name = name;
      _api.pushRoute(pushRouteMessage);
    }
  }

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Route _makeRoute(Map<String, RouterRoute> routes, RouteSettings settings) {
    return routes[settings.name].func(settings.arguments);
  }

  static Widget _materialAppBuilder(RouteFactory routerFactory) {
    return MaterialApp(onGenerateRoute: routerFactory);
  }

  @override
  Widget build(BuildContext context) {
    return _appBuilder((RouteSettings settings) {
      return _makeRoute(routeMap, settings);
    });
  }
}

enum RouteLocation {
  host,
  flutter,
}

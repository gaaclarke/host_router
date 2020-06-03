import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:host_router/host_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HostRouterApp(routeMap: {
      '/page3' : RouterRoute(location: RouteLocation.host),
      '/page2' : RouterRoute(location: RouteLocation.flutter, func: (args) {
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => Page2());
      }),
      '/' : RouterRoute(location: RouteLocation.flutter, func: (args) {
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => Page1());
      }),
    });
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1 example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('hi'),
            RaisedButton(
              child: Text('Go!'),
              onPressed: () {
                RouterNavigator.of(context).push('/page2');
              },
            ),
          ]
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2 example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('hi'),
            RaisedButton(
              child: Text('Go!'),
              onPressed: () {
                RouterNavigator.of(context).push('/page3');
              },
            ),
          ]
        ),
      ),
    );
  }
}

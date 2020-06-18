import 'package:pigeon/pigeon.dart';

class PushRoute {
  String name;
}

class PopRoute{
  String name;
}

@HostApi()
abstract class HostRouterApi {
  void pushRoute(PushRoute info);
  void popRoute(PopRoute info);
}

@FlutterApi()
abstract class FlutterRouterApi {
  void pushRoute(PushRoute info);
  void popRoute();
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'HR';
  opts.javaOut = 'android/src/main/java/com/example/host_router/Messages.java';
}

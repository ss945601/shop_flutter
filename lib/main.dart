import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:apps/router_manager.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'config.dart';

void main() {
  var routerManager = RouterManager.instance;
  runApp(Portal(
      child: GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: appName,
    theme: ThemeData(fontFamily: "NotoSans").copyWith(
      scaffoldBackgroundColor: bgColor,
      canvasColor: secondaryColor,
    ),
    initialRoute: Routers.home.path,
    getPages: routerManager.getPages(),
  )));
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    // Some android/ios specific code
  } else if (defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = desktopWindowSize;
      // win.minSize = initialSize;
      // win.maxSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = appName;
      win.show();
    }); // Some desktop specific code there
  } else {
    // Some web specific code there
  }
}

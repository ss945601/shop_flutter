import 'package:apps/cubit/device_info_cubit.dart';
import 'package:apps/cubit/order_cubit.dart';
import 'package:apps/cubit/scan_cubit.dart';
import 'package:apps/cubit/shop_cubit.dart';
import 'package:flutter/material.dart';
import 'package:apps/util.dart';
import 'package:apps/views/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

extension RoutersExtension on Routers {
  String get path {
    return '/' + toString().replaceAll("Routers.", "");
  }
}

// ** Add path name to router
// ignore: constant_identifier_names
enum Routers { home }

class RouterManager {
  RouterManager._privateConstructor();

  static final RouterManager _instance = RouterManager._privateConstructor();

  static RouterManager get instance => _instance;
  // ** Add <Routers,Widget> to map
  Map<Routers, Widget> routers = {
    Routers.home: MultiBlocProvider(
      providers: [
        BlocProvider<DeviceInfoCubit>(
          create: (BuildContext context) => DeviceInfoCubit(),
        ),
        BlocProvider<ScanCubit>(
          create: (BuildContext context) => ScanCubit(),
        ),
        BlocProvider<ShopCubit>(
          create: (BuildContext context) => ShopCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (BuildContext context) => OrderCubit(),
        ),
      ],
      child: Home(),
    )
  };

  List<GetPage<dynamic>> getPages() {
    Util.instance.logger.i("Setting router");
    List<GetPage<dynamic>> routerList = [];
    routers.forEach((k, v) {
      routerList.add(GetPage(name: k.path, page: () => v));
    });
    return routerList;
  }
}

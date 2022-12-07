import 'package:apps/views/orderList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../cubit/shop_cubit.dart';
import '../desktop_view/window_bar.dart';
import '../responsive.dart';
import 'package:lottie/lottie.dart';

import 'shop.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Widget page = Container();
  late final AnimationController _boarderController;
  bool isZoom = false;

  void switchPage(Widget newPage) {
    setState(() {
      _boarderController.duration = Duration(seconds: 3);
      _boarderController.forward(from: 0);
      page = newPage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _boarderController = AnimationController(vsync: this);
    _boarderController.duration = Duration(seconds: 3);
    _boarderController.forward(from: 1);
    context.read<ShopCubit>().processCsv(context);
    switchPage(Container(margin: EdgeInsets.all(30), child: Shop(switchPage)));
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      onInteractionStart: (details) {
        if (details.pointerCount >= 2 && !isZoom && kIsWeb) {
          setState(() {
            isZoom = true;
          });
        }
      },
      onInteractionEnd: (details) {
        if (isZoom) {
          setState(() {
            isZoom = false;
          });
        }
      },
      scaleFactor: 500,
      constrained: false,
      panEnabled: true,
      scaleEnabled: isZoom,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            appBar: !Responsive.isDesktop(context)
                ? AppBar(
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [backgroundStartColor, backgroundEndColor],
                            stops: const [0.4, 1.0]),
                      ),
                    ),
                    title: TextButton(
                      child: const Text(appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      onPressed: () {},
                    ),
                  )
                : null,
            drawer: Responsive.isDesktop(context)
                ? SizedBox.shrink()
                : SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: SideMenu(switchPage)),
            body: WindowBar(
                contents: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    SizedBox(
                      // default flex = 1
                      width: MediaQuery.of(context).size.width / 4,
                      // and it takes 1/6 part of the screen
                      child: SideMenu(switchPage),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color.fromARGB(255, 80, 91, 99),
                              Color.fromARGB(255, 4, 39, 70),
                            ],
                          )),
                          child: Lottie.asset(
                            'assets/lottie/background.json',
                            controller: _boarderController,
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        page
                      ],
                    ),
                  ),
                ]))),
      ),
    );
  }
}

// ignore: must_be_immutable
class SideMenu extends StatefulWidget {
  SideMenu(this.switchPage, {Key? key}) : super(key: key);
  Function switchPage;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Lottie.asset(
            'assets/lottie/sidebar.json',
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          ListView(
            children: [
              DrawerHeader(
                child: IconButton(
                  icon: Image.asset("assets/images/logo.png"),
                  iconSize: 50,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              DrawerListTile(
                title: "商品列表",
                svgSrc: "assets/icons/menu_dashbord.svg",
                press: () {
                  widget.switchPage(Container(
                      margin: EdgeInsets.all(30),
                      child: Shop(widget.switchPage)));
                  context.read<ShopCubit>().processCsv(context);
                  Get.back();
                },
              ),
              DrawerListTile(
                title: "訂單查詢",
                svgSrc: "assets/icons/Search.svg",
                press: () {
                  widget.switchPage(OrderList(widget.switchPage));
                  context.read<ShopCubit>().processCsv(context);
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  State<DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile>
    with TickerProviderStateMixin {
  bool isHover = false;
  bool isTap = false;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTapDown: (value) {
        setState(() {
          isTap = true;
        });
      },
      onTapUp: (value) {
        setState(() {
          isTap = false;
        });
      },
      onHover: ((value) {
        setState(() {
          if (value) {
            _controller.forward(from: 0.0);
          } else {
            _controller.forward(from: 0.0);
            _controller.stop();
            isTap = false;
          }
          isHover = value;
        });
      }),
      child: Container(
        color: !isTap ? Colors.white.withAlpha(0) : Colors.black.withAlpha(20),
        height: MediaQuery.of(context).size.height / 8,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                child: SvgPicture.asset(
                  widget.svgSrc,
                  color: !isHover ? Colors.white54 : Colors.white,
                  height: 20,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                widget.title,
                style: TextStyle(
                    color: !isHover ? Colors.white54 : Colors.white,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

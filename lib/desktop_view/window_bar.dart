// ignore_for_file: must_be_immutable

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:apps/config.dart';

import '../responsive.dart';

class WindowBar extends StatelessWidget {
  WindowBar({required this.contents, Key? key}) : super(key: key);
  Widget contents;
  final borderColor = const Color(0xFF805306);
  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Column(children: [
        Expanded(flex: 1, child: contents),
      ]);
      // Some android/ios specific code
    } else if (Responsive.isDesktop(context)) {
      return WindowBorder(
        color: borderColor,
        width: 0,
        child: Column(
          children: [
            Row(
              children: [
                WindowBarContents(
                  title: const Text(
                    appName,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            Expanded(flex: 20, child: contents),
          ],
        ),
      );
      // Some desktop specific code there
    } else {
      return Container(child: contents);
      // Some web specific code there
    }
  }
}

class WindowBarContents extends StatelessWidget {
  WindowBarContents({required this.title, Key? key}) : super(key: key);
  Widget title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: const [0.4, 1.0]),
        ),
        child: Column(children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 5)),
                SvgPicture.asset(
                  desktopWindowIconPath,
                  height: 20,
                  width: 20,
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                title,
                Expanded(child: MoveWindow()),
                const WindowButtons()
              ],
            ),
          )
        ]),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Colors.black,
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: Colors.white,
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: Colors.black,
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

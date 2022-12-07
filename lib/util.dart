import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

enum Events { saveList, removeBookedList }

class EventsWithParam {
  Events evt;
  dynamic param;
  EventsWithParam(this.evt, [this.param]);
}

class Util {
  Util._privateConstructor() {
    EquatableConfig.stringify = true;
  }

  static final Util _instance = Util._privateConstructor();

  static Util get instance => _instance;

  var logger = Logger();

  EventBus eventBus = EventBus();

  Future<void> showMyDialog(BuildContext ctx, String title, Widget content,
      EventsWithParam event) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                eventBus.fire(event);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class HttpService {
  late Dio _dio;

  final baseUrl;

  static Future<void> openUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  HttpService(this.baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    initializeInterceptors();
  }

  Future<Response> _request(String path, {required String method}) async {
    Response response;
    try {
      response = await _dio.request(path, options: Options(method: method));
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  Future<Response> get(String path) async {
    return _request(path, method: 'get');
  }

  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}

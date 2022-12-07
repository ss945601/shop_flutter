part of 'scan_cubit.dart';

abstract class ScanState extends Equatable {
  const ScanState(this.scanModel);
  final ScanModel scanModel;
  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {
  ScanInitial(super.scanModel);
}

class ScanDone extends ScanState {
  ScanDone(super.scanModel);
}

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
    required this.updateDate,
    required this.adb,
    required this.appList,
  });

  final String updateDate;
  final String adb;
  final List<AppList> appList;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        updateDate: json["updateDate"],
        adb: json["Adb"],
        appList:
            List<AppList>.from(json["appList"].map((x) => AppList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "updateDate": updateDate,
        "Adb": adb,
        "appList": List<dynamic>.from(appList.map((x) => x.toJson())),
      };
}

class AppList {
  AppList({
    required this.packageName,
    required this.connections,
  });

  final String packageName;
  final Connections connections;

  factory AppList.fromJson(Map<String, dynamic> json) => AppList(
        packageName: json["packageName"],
        connections: Connections.fromJson(json["connections"]),
      );

  Map<String, dynamic> toJson() => {
        "packageName": packageName,
        "connections": connections.toJson(),
      };
}

class Connections {
  Connections({
    required this.urlList,
    required this.description,
  });

  final List<UrlList> urlList;
  final String description;

  factory Connections.fromJson(Map<String, dynamic> json) => Connections(
        urlList:
            List<UrlList>.from(json["UrlList"].map((x) => UrlList.fromJson(x))),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "UrlList": List<dynamic>.from(urlList.map((x) => x.toJson())),
        "description": description,
      };
}

class UrlList {
  UrlList({
    required this.type,
    required this.port,
    required this.url,
  });

  final Type type;
  final String port;
  final String url;

  factory UrlList.fromJson(Map<String, dynamic> json) => UrlList(
        type: typeValues.map[json["type"]]!,
        port: json["port"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "port": port,
        "url": url,
      };
}

enum Type { HTTPS, HTTP, TCP, UDP }

final typeValues = EnumValues(
    {"http": Type.HTTP, "https": Type.HTTPS, "tcp": Type.TCP, "udp": Type.UDP});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

import 'dart:typed_data';

class AppModel {
    final int? appInfoId;
    final String appName;
    final String appPackageName;
    final Uint8List appIcon;
    final String timeSpent;
    final String? createdAt;
    

    AppModel({
        this.appInfoId,
        required this.appName,
        required this.appPackageName,
        required this.appIcon,
        required this.timeSpent,
        this.createdAt,
    });

    factory AppModel.fromMap(Map<String, dynamic> json) => AppModel(
        appInfoId: json["appInfoId"],
        appName: json["appName"],
        appPackageName: json["appPackageName"],
        appIcon: json["appIcon"],
        timeSpent:json["timeSpent"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toMap() => {
        "appInfoId": appInfoId,
        "appName": appName,
        "appPackageName": appPackageName,
        "appIcon": appIcon,
        "timeSpent":timeSpent,
        "createdAt": createdAt,
    };
}
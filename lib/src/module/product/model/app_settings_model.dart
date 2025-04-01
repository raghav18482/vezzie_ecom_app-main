// To parse this JSON data, do
//
//     final appSettings = appSettingsFromJson(jsonString);

import 'dart:convert';

AppSettings appSettingsFromJson(String str) => AppSettings.fromJson(json.decode(str));

String appSettingsToJson(AppSettings data) => json.encode(data.toJson());

class AppSettings {

    Settings settings;

    AppSettings({

        required this.settings,
    });

    factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
   
        settings: Settings.fromJson(json["settings"]),
    );

    Map<String, dynamic> toJson() => {
 
        "settings": settings.toJson(),
    };
}

class Settings {
    Banner banner;
    Banner banner2;
    String id;
    String appTitle;
    String appSlogan;
    List<String> carousel;
    List<String> carousel2;
    String appVersion;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    List<String> carouselOneUrl;
    List<String> carouselTwoUrl;

    Settings({
        required this.banner,
        required this.banner2,
        required this.id,
        required this.appTitle,
        required this.appSlogan,
        required this.carousel,
        required this.carousel2,
        required this.appVersion,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.carouselOneUrl,
        required this.carouselTwoUrl,
    });

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        banner: Banner.fromJson(json["banner"]),
        banner2: Banner.fromJson(json["banner2"]),
        id: json["_id"],
        appTitle: json["appTitle"],
        appSlogan: json["appSlogan"],
        carousel: List<String>.from(json["carousel"].map((x) => x)),
        carousel2: List<String>.from(json["carousel2"].map((x) => x)),
        appVersion: json["appVersion"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        carouselOneUrl: List<String>.from(json["carousel_one_url"].map((x) => x)),
        carouselTwoUrl: List<String>.from(json["carousel_two_url"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "banner": banner.toJson(),
        "banner2": banner2.toJson(),
        "_id": id,
        "appTitle": appTitle,
        "appSlogan": appSlogan,
        "carousel": List<dynamic>.from(carousel.map((x) => x)),
        "carousel2": List<dynamic>.from(carousel2.map((x) => x)),
        "appVersion": appVersion,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "carousel_one_url": List<dynamic>.from(carouselOneUrl.map((x) => x)),
        "carousel_two_url": List<dynamic>.from(carouselTwoUrl.map((x) => x)),
    };
}

class Banner {
    String titleLeft;
    String title;
    String titleRight;
    String imgUrl;
    String routeId;

    Banner({
        required this.titleLeft,
        required this.title,
        required this.titleRight,
        required this.imgUrl,
        required this.routeId,
    });

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        titleLeft: json["titleLeft"],
        title: json["title"],
        titleRight: json["titleRight"],
        imgUrl: json["imgUrl"],
        routeId: json["routeID"],
    );

    Map<String, dynamic> toJson() => {
        "titleLeft": titleLeft,
        "title": title,
        "titleRight": titleRight,
        "imgUrl": imgUrl,
        "routeID": routeId,
    };
}

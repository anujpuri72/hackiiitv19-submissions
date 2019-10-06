// To parse this JSON data, do
//
//     final mandi = mandiFromJson(jsonString);

import 'dart:convert';

Mandi mandiFromJson(String str) => Mandi.fromJson(json.decode(str));

String mandiToJson(Mandi data) => json.encode(data.toJson());

class Mandi {
  List<dynamic> mandisList;
  List<MandiElement> mandis;

  Mandi({
    this.mandisList,
    this.mandis,
  });

  factory Mandi.fromJson(Map<dynamic, dynamic> json) => Mandi(
        mandisList: List<dynamic>.from(json["mandisList"].map((x) => x)),
        mandis: List<MandiElement>.from(
            json["mandis"].map((x) => MandiElement.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "mandisList": List<dynamic>.from(mandisList.map((x) => x)),
        "mandis": List<dynamic>.from(mandis.map((x) => x.toJson())),
      };
}

class MandiElement {
  String district;
  String name;
  int trader;
  List<Commodity> commodities;
  int farmer;
  String state;
  List<Commodity> commodity;

  MandiElement({
    this.district,
    this.name,
    this.trader,
    this.commodities,
    this.farmer,
    this.state,
    this.commodity,
  });

  factory MandiElement.fromJson(Map<dynamic, dynamic> json) => MandiElement(
        district: json["district"],
        name: json["name"],
        trader: json["trader"],
        commodities: json["commodities"] == null
            ? null
            : List<Commodity>.from(
                json["commodities"].map((x) => Commodity.fromJson(x))),
        farmer: json["farmer"],
        state: json["state"],
        commodity: json["commodity"] == null
            ? null
            : List<Commodity>.from(
                json["commodity"].map((x) => Commodity.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "district": district,
        "name": name,
        "trader": trader,
        "commodities": commodities == null
            ? null
            : List<dynamic>.from(commodities.map((x) => x.toJson())),
        "farmer": farmer,
        "state": state,
        "commodity": commodity == null
            ? null
            : List<dynamic>.from(commodity.map((x) => x.toJson())),
      };
}

class Commodity {
  String name;
  int priceModal;
  int priceMin;
  int demand;
  int supply;
  int priceMax;

  Commodity({
    this.name,
    this.priceModal,
    this.priceMin,
    this.demand,
    this.supply,
    this.priceMax,
  });

  factory Commodity.fromJson(Map<dynamic, dynamic> json) => Commodity(
        name: json["name"],
        priceModal: json["price_modal"],
        priceMin: json["price_min"],
        demand: json["demand"],
        supply: json["supply"],
        priceMax: json["price_max"],
      );

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "price_modal": priceModal,
        "price_min": priceMin,
        "demand": demand,
        "supply": supply,
        "price_max": priceMax,
      };
}

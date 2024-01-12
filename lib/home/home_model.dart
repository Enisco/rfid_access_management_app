import 'dart:convert';

AccessDataModel accessDataModelFromJson(String str) =>
    AccessDataModel.fromJson(json.decode(str));

String accessDataModelToJson(AccessDataModel data) =>
    json.encode(data.toJson());

class AccessDataModel {
  final String? id;
  final String? holderName;
  final bool? grantAccess;
  final bool? isTimed;
  final int? endTime;

  AccessDataModel({
    this.id,
    this.holderName,
    this.grantAccess,
    this.isTimed,
    this.endTime,
  });

  AccessDataModel copyWith({
    String? id,
    String? holderName,
    bool? grantAccess,
    bool? isTimed,
    int? endTime,
  }) =>
      AccessDataModel(
        id: id ?? this.id,
        holderName: holderName ?? this.holderName,
        grantAccess: grantAccess ?? this.grantAccess,
        isTimed: isTimed ?? this.isTimed,
        endTime: endTime ?? this.endTime,
      );

  factory AccessDataModel.fromJson(Map<String, dynamic> json) =>
      AccessDataModel(
        id: json["id"],
        holderName: json["holderName"],
        grantAccess: json["grantAccess"],
        isTimed: json["isTimed"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holderName": holderName,
        "grantAccess": grantAccess,
        "isTimed": isTimed,
        "endTime": endTime,
      };
}

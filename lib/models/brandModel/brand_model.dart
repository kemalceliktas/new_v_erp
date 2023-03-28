import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class BrandFields {
  static const String name = "name";
  static const String id = "id";
  static const String cari1 = "cari1";
  static const String cari2 = "cari2";
  static const String cari3 = "cari3";
  static const String cari4 = "cari4";
  static const String status = "status";

  static List<dynamic> getFields() => [id,name,  cari1, cari2, cari3, cari4,status];
}

// ignore: must_be_immutable
class BrandModel extends Equatable {
  String? name;
  String? id;
  String? cari1;
  String? cari2;
  String? cari3;
  String? cari4;
  String? status;

  BrandModel({
    required this.name,
    required this.id,
    required this.cari1,
    required this.cari2,
    required this.cari3,
    required this.cari4,
    required this.status,
  });

  BrandModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    cari1 = json["cari1"];
    cari2 = json["cari2"];
    cari3 = json["cari3"];
    cari4 = json["cari4"];
    status=json["status"];
  }

  Map<String, dynamic> toJson() => {
        BrandFields.name: name,
        BrandFields.id: id ?? const Uuid().v4(),
        BrandFields.cari1: cari1,
        BrandFields.cari2: cari2,
        BrandFields.cari3: cari3,
        BrandFields.cari4: cari4,
        BrandFields.status:status,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [name, id,status];
}

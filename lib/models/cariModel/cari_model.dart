import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/*  "ID": 32,
      "Type": 0,
      "CompanyTitle": "Test Unvan",
      "Name": "Test Ad",
      "LastName": "Test Soyad",
      "Phone": "5554443311",
      "Email": "test@test.com",      
      "IdentificationNumber": "55544404445",
      "TaxAdministration": null,
      "TaxNumber": null,
      "Password": null,
      "CityCode": 16,
      "DistrictCode": null,
      "Address": "Test Adres Detay",
      "Status": null,
      "UpdateDate": "24/2/2023 12:51:40",
      "CreateDate": "24/2/2023 12:51:40" */

class CariFields {
  static const String name = "name";
  static const String id = "id";
  static const String status = "status";
  static const String type = "type";
  static const String lastName = "lastName";
  static const String phone = "phone";
  static const String email = "email";
  static const String identificationNumber = "identificationNumber";
  static const String taxNumber = "taxNumber";
  static const String cityCode = "cityCode";
  static const String address = "address";

  static List<dynamic> getFields() => [
        id,
        name,
        status,
        type,
        lastName,
        phone,
        email,
        identificationNumber,
        taxNumber,
        cityCode,
        address,
      ];
}

// ignore: must_be_immutable
class CariModel extends Equatable {
  String? name;
  String? id;
  String? status;
  String? type;
  String? lastName;
  String? phone;
  String? email;
  String? identificationNumber;
  String? taxNumber;
  String? cityCode;
  String? address;

  CariModel({
    required this.name,
    required this.id,
    required this.status,
    required this.type,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.email,
    required this.identificationNumber,
    required this.taxNumber,
    required this.cityCode,
  });

  CariModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    status = json["status"];
    type=json["type"];
    lastName=json["lastName"];
    phone=json["phone"];
    email=json["email"];
    identificationNumber=json["identificationNumber"];
    taxNumber=json["taskNumber"];
    cityCode=json["cityCode"];
    address=json["address"];
  }

  Map<String, dynamic> toJson() => {
        CariFields.name: name,
        CariFields.id: id ?? const Uuid().v4(),
        CariFields.status: status,
        CariFields.type:type,
        CariFields.lastName:lastName,
        CariFields.phone:phone,
        CariFields.email:email,
        CariFields.identificationNumber:identificationNumber,
        CariFields.taxNumber:taxNumber,
        CariFields.cityCode:cityCode,
        CariFields.address:address,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [name, id, status];
}

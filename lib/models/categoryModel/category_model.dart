import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class CategoryFields {
  static const String name = "name";
  static const String id = "id";
  static const String status = "status";
  

  static List<dynamic> getFields() => [id,name, status];
}

// ignore: must_be_immutable
class CategoryModel extends Equatable {
  String? name;
  String? id;
  String? status;
  
  CategoryModel(
      {required this.name,
      required this.id,
      required this.status
      });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    status=json["status"];
  
  }

  Map<String, dynamic> toJson() => {
        CategoryFields.name: name,
        CategoryFields.id: id ?? const Uuid().v4(),
        CategoryFields.status:status,
       
      };

  @override
  // TODO: implement props
  List<Object?> get props => [name, id,status];
}

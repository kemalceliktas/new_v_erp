import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class UserFields {
  static const String id = "id";
  static const String name = "name";
  static const String email = "email";
  static const String password = "password";
  static const String isAdmin = "isAdmin";
  static const String notes="notes";
  static List<dynamic> getFields() => [id, name, email, password, isAdmin,];
}

//
class User extends Equatable {
  String? id;
  String? name;
  String? email;
  bool? isAdmin;
  String? password;
  List<String>?notes;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.password,
    this.notes,


  });
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    isAdmin = json['isAdmin'];
    notes=json["notes"];
  
    
  }

  Map<String, dynamic> toJson() => {
        UserFields.id: id = id ?? const Uuid().v4(),
        UserFields.name: name,
        UserFields.email: email,
        UserFields.password: password,
        UserFields.isAdmin: isAdmin,
        UserFields.notes:notes,
       
        
      };


      @override
  List<Object?> get props => [id, name, email, isAdmin, password, notes];
}







class NoteFields {
  static const String id = "id";
  static const String title = "title";
  static const String description= "description";
  static const String date = "date";
  static const String isPaid = "isPaid";
  static const String lastDate="lastDate";
  static const String category="category";
  static List<dynamic> getFields() => [id, title, description, date, isPaid,lastDate,category];
}

//
class Note  extends Equatable{
  String? id;
  String? title;
  String? description;
  String? date;
  String? isPaid;
  String? lastDate;
  String? category;
  

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.isPaid,
    required this.lastDate,
    required this.date,
    required this.category,


  });
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    isPaid = json['isPaid'];
    lastDate=json["lastDate"];
    category=json["category"];
  
    
  }

  Map<String, dynamic> toJson() => {
        NoteFields.id: id = id ?? const Uuid().v4(),
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.isPaid: isPaid,
        NoteFields.lastDate: lastDate,
        NoteFields.date:date,
        NoteFields.category:category,
       
        
      };
      
      @override
  List<Object?> get props =>
      [id, title, description, isPaid, lastDate, date, category];
}




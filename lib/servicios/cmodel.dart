/// To parse this JSON data, do
//
//     final solicitudesmodel = solicitudesmodelFromJson(jsonString);

import 'dart:convert';

Cmodel cmodelFromJson(String str) => Cmodel.fromJson(json.decode(str));

String cmodelToJson(Cmodel data) => json.encode(data.toJson());

class Cmodel {
  Cmodel({
    required this.nombre,
    required this.id,
  });
  String nombre;
  String id="";

  factory Cmodel.fromJson(Map<String, dynamic> json) => Cmodel(
        nombre: json["nombre"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "id": id,
      };
}

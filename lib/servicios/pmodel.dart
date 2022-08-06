/// To parse this JSON data, do
//
//     final solicitudesmodel = solicitudesmodelFromJson(jsonString);

import 'dart:convert';

Pmodel pmodelFromJson(String str) => Pmodel.fromJson(json.decode(str));

String pmodelToJson(Pmodel data) => json.encode(data.toJson());

class Pmodel {
  Pmodel({
    required this.nombre,
    required this.cat,
    required this.precio,
    required this.fotourl,
    required this.stock,
    required this.id,
    required this.tipo,
    required this.variantes,
    required this.costetotal,
    required this.colorimagen,
    required this.color,
  });
  String nombre;
  String cat;
  String precio;
  String fotourl;
  String stock;
  String id;
  bool tipo;
  bool variantes;
  String costetotal;
  bool colorimagen;
  String color;

  factory Pmodel.fromJson(Map<String, dynamic> json) => Pmodel(
        nombre: json["nombre"],
        cat: json["cat"],
        precio: json["precio"],
        fotourl: json["fotourl"],
        stock: json["stock"],
        id: json["id"],
        tipo: json["tipo"],
        variantes: json["variantes"],
        costetotal: json["costetotal"],
        colorimagen: json["colorimagen"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "cat": cat,
        "precio": precio,
        "fotourl": fotourl,
        "stock": stock,
        "id": id,
        "tipo": tipo,
        "variantes": variantes,
        "costetotal": costetotal,
        "colorimagen": colorimagen,
        "color": color,
      };
}

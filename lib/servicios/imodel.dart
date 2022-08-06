/// To parse this JSON data, do
//
//     final solicitudesmodel = solicitudesmodelFromJson(jsonString);

import 'dart:convert';

Imodel imodelFromJson(String str) => Imodel.fromJson(json.decode(str));

String imodelToJson(Imodel data) => json.encode(data.toJson());

class Imodel {
  Imodel({
    required this.nombre,
    required this.coste,
    required this.costefinal,
    required this.costetotal,
    required this.stock,
    required this.id,
    required this.idruta,
    required this.medida,
    required this.cantidad,
    required this.precio,
    required this.codigo,
  });
  String nombre;
  String coste;
  String costefinal;
  String costetotal;
  String stock;
  String id;
  String idruta;
  String medida;
  String cantidad;
  String precio;
  String codigo;

  factory Imodel.fromJson(Map<String, dynamic> json) => Imodel(
        nombre: json["nombre"],
        coste: json["coste"],
        costefinal: json["costefinal"],
        costetotal: json["costetotal"],
        stock: json["stock"],
        id: json["id"],
        idruta: json["idruta"],
        medida: json["medida"],
        cantidad: json["cantidad"],
        precio: json["precio"],
        codigo: json["codigo"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "coste": coste,
        "costefinal": costefinal,
        "costetotal": costetotal,
        "stock": stock,
        "id": id,
        "idruta": idruta,
        "medida": medida,
        "cantidad": cantidad,
        "precio": precio,
        "codigo": codigo,
      };
}

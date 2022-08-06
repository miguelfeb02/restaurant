// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print,

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/imodel.dart';

class Addins extends StatefulWidget {
  @override
  _AddinsState createState() => _AddinsState();
}

class _AddinsState extends State<Addins> {
  final provider = Providerx();
  final pre = PreferenciasUsuario();
  final Controllerinsumos data = Get.put(Controllerinsumos());

  Imodel imodel = Imodel(
      nombre: "",
      coste: "",
      costefinal: "",
      costetotal: "",
      stock: "0",
      id: "",
      idruta: "",
      medida: "",
      codigo: "",
      cantidad: "",
      precio: "");

  List<String> medidas = ["gr", "ml"];
  var refnueva = "";
  var subiendo = false;
  String u = "gr";
  var sizes = Get.size;
  var cambio = false;
  final formKey = GlobalKey<FormState>();
  final GetXNetworkManager conexion = Get.put(GetXNetworkManager());
  @override
  Widget build(BuildContext context) {
    if (cambio == false) {
      refnueva = (int.parse(data.ref) + 1).toString();
      imodel.codigo = refnueva;
    }

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(12, 60, 64, 1),
              title: Text(
                "Agregar insumo",
                style: TextStyle(fontSize: 16),
              ),
              centerTitle: true,
              elevation: 10,
            ),
            body: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Texto vacio";
                        } else {
                          List igual = [];
                          for (var i = 0; i < data.insumos.length; i++) {
                            if (data.insumos[i].nombre == value.toLowerCase()) {
                              igual.add(data.insumos[i].nombre);
                            }
                          }
                          if (igual.isNotEmpty) {
                            return "Ya existe un insumo con este nombre";
                          } else {
                            return null;
                          }
                        }
                      },
                      onSaved: (newValue) {
                        imodel.nombre = newValue.toString();
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          label: Text("Nombre de insumo"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Texto vacio";
                        } else {
                          var x = int.parse(value) + 0;
                          if (x == 0) {
                            return "No puede ser 0 ";
                          }
                        }
                      },
                      onSaved: (newValue) {
                        imodel.coste = newValue!;
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(4),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          label: Text("Coste por $u"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            initialValue: "0",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Texto vacio";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              imodel.stock = newValue!;
                            },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                label: Text("Stock inicial"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: DropdownButtonFormField(
                            value: medidas[0],
                            onSaved: (newValue) {
                              imodel.medida = newValue.toString();
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onChanged: (value) {
                              u = value.toString();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {});
                            },
                            items: medidas.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: TextStyle(
                                    color: Color.fromRGBO(12, 60, 64, 1),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: refnueva,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Texto vacio";
                        } else {
                          List igual = [];
                          for (var i = 0; i < data.insumos.length; i++) {
                            if (data.insumos[i].codigo == value.toLowerCase()) {
                              igual.add(data.insumos[i].codigo);
                            }
                          }
                          if (igual.isNotEmpty) {
                            return "Ya existe esta referencia";
                          } else {
                            var x = int.parse(value);
                            if (x == 0) {
                              return "No puede ser 0 ";
                            } else {
                              var x = int.parse(value);
                              if (x < 10000) {
                                return "Debe ser un numero mayor a 10000 ";
                              }
                            }
                          }
                        }
                      },
                      onChanged: (value) {
                        cambio = true;
                        refnueva = value;
                        imodel.codigo = refnueva;
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(8),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          label: Text("REF"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                        child: Text(
                          "Agregar Insumo",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color.fromRGBO(12, 60, 64, 1),
                        onPressed: () async {
                          if (conexion.connectionType == 0) {
                            dialogointernet();
                          } else {
                            print(refnueva);
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              setState(() {
                                subiendo = true;
                              });
                              final instrue =
                                  await provider.crearinsumo(imodel);
                              await provider.refa(refnueva);
                              setState(() {
                                subiendo = false;
                              });
                              if (instrue) {
                                Navigator.pop(context);
                                Controllerinsumos.to.actualizar();
                                Controllerinsumos.to.actualizaref();
                                pre.tab = 1;
                              }
                            }
                          }
                        })
                  ],
                ),
              ),
            )),
        subiendo
            ? Scaffold(
                body: Container(
                  height: sizes.height,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              )
            : Container(),
        subiendo
            ? Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: sizes.height * 0.45,
                        ),
                        SpinKitFadingCube(
                          color: Color.fromRGBO(12, 60, 64, 1),
                          size: 40,
                        ),
                        SizedBox(
                          height: sizes.height * 0.05,
                        ),
                        Text(
                          "Creando insumo",
                          style: TextStyle(
                              color: Color.fromRGBO(12, 60, 64, 1),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  height: sizes.height,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              )
            : Container()
      ],
    );
  }

  dialogointernet() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: Text(
            "Sin conexion a internet",
            style: TextStyle(
                color: Color.fromRGBO(12, 60, 64, 1),
                fontFamily: "evel",
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text("OK")),
          ],
        );
      },
    );
  }
}

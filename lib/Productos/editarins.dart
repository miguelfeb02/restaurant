// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print,

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/imodel.dart';

class Editarins extends StatefulWidget {
  @override
  _EditarinsState createState() => _EditarinsState();
}

class _EditarinsState extends State<Editarins> {
  final provider = Providerx();
  final pre = PreferenciasUsuario();
  Imodel imodel = Imodel(
      nombre: "",
      codigo: "",
      coste: "",
      costefinal: "",
      costetotal: "",
      stock: "0",
      id: "",
      idruta: "",
      medida: "",
      cantidad: "",
      precio: "");

  List<String> medida = ["gr", "ml"];

  var subiendo = false;
  String u = "gr";
  var sizes = Get.size;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final insdata = ModalRoute.of(context)!.settings.arguments as Imodel;
    return WillPopScope(
      onWillPop: () async {
        if (subiendo == false) {
          Navigator.pop(context);
        }

        return false;
      },
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                title: Text(
                  "Editar insumo",
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
                        initialValue: insdata.nombre,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Texto vacio";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          imodel.nombre = newValue!;
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(20),
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
                        initialValue: insdata.coste,
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
                              enabled: true,
                              initialValue: insdata.stock,
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
                                  label: Text("Stock"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: DropdownButtonFormField(
                              value: insdata.medida,
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {});
                              },
                              items: medida.map((String val) {
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
                        initialValue: insdata.codigo,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: false,
                        onSaved: (newValue) {
                          imodel.codigo = newValue!;
                        },
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
                            "Editar Insumo",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromRGBO(12, 60, 64, 1),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              setState(() {
                                subiendo = true;
                              });
                              final ingtrue1 = await provider.editarinsumo(
                                  imodel, insdata.id);
                               provider.editarcostes(
                                  insdata.id, imodel.coste);
                                  
                              setState(() {
                                subiendo = false;
                              });
                              
                              if (ingtrue1 ) {
                                Navigator.pop(context);
                                Controllerinsumos.to.actualizar();
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
                            "Editando insumo",
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
      ),
    );
  }
}

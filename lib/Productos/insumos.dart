// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';
import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/controllers/controllerpro.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/widgets.dart';

class Insumos extends StatefulWidget {
  @override
  _InsumosState createState() => _InsumosState();
}

class _InsumosState extends State<Insumos> {
  final provider = Providerx();
  final widgets = Widgets();
  final pre = PreferenciasUsuario();
  var sizes = Get.size;
  var cantidad = 0;
  var editando = false;
  var creando = false;
  var eliminando = false;
  var consultando = false;
  var restablecer = false;
  final llavepass = GlobalKey<FormState>();
  TextEditingController editorpass = TextEditingController();
  ScrollController control = ScrollController();
  final Controllerinsumos dataconteo = Get.put(Controllerinsumos());
  final GetXNetworkManager conexion = Get.put(GetXNetworkManager());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            drawer: widgets.drawer(context),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(12, 60, 64, 1),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_link_rounded,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Insumos",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              centerTitle: true,
              elevation: 10,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<Controllerinsumos>(builder: (value) {
                      return value.actual
                          ? SpinKitFadingCube(
                              color: Colors.white,
                              size: 10,
                            )
                          : SizedBox(
                              width: sizes.width * 0.025,
                            );
                    }),
                    SizedBox(
                      width: sizes.width * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            if (dataconteo.insumos.isNotEmpty &&
                                dataconteo.insumos[0] == "error") {
                            } else {
                              Navigator.pushNamed(context, "adding");
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: insumos(),
                ),
                cantidadinsumos()
              ],
            )),
        stackloading()
      ],
    );
  }

  cantidadinsumos() {
    return Container(
      height: sizes.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<Controllerinsumos>(
              init: Controllerinsumos(),
              builder: (value) {
                return Text(
                  "Insumos : ${value.cantidad}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                );
              })
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey))),
    );
  }

  insumos() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: GetBuilder<Controllerinsumos>(
        builder: (value) {
          List insumos = value.insumos;
          List insumosx = insumos.reversed.toList();
          if (value.insumos.isNotEmpty && value.insumos[0] == "error") {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: sizes.height * 0.3,
                  ),
                  Text("Sin conexion a internet"),
                  TextButton(
                      onPressed: () async {
                        if (conexion.connectionType == 0) {
                          dialogointernet();
                        } else {
                          setState(() {
                            restablecer = true;
                          });
                          await Controllercats.to.actualizar();
                          await Controllerpro.to.actualizar();
                          await Controllerinsumos.to.actualizar();
                          setState(() {
                            restablecer = false;
                          });
                        }
                      },
                      child: Text("Reintentar conexion"))
                ],
              ),
            );
          } else {
            if (value.esperando) {
              if (insumosx.isNotEmpty) {
                return Scrollbar(
                  child: ListView.builder(
                    // controller: control,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: insumosx.length,
                    itemBuilder: (BuildContext context, int index) {
                      return card(insumosx, index);
                    },
                  ),
                );
              } else {
                return Center(
                    child: Text(
                  "No hay insumos creados",
                  style: TextStyle(
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                ));
              }
            } else {
              return Center(
                child: SpinKitFadingCube(
                  size: 40,
                  color: Color.fromRGBO(12, 60, 64, 1),
                ),
              );
            }
          }
        },
      ),
    );
  }

  card(datacheck, index) {
    final sizes = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
          color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(
              width: sizes.width * 0.09,
              child: Icon(
                Icons.food_bank,
                color: Color.fromRGBO(12, 60, 64, 1),
              )),
          SizedBox(
            width: sizes.width * 0.03,
          ),
          Column(
            children: [
              SizedBox(
                width: sizes.width * 0.38,
                child: Text(
                  datacheck[index].nombre.toUpperCase(),
                  style: TextStyle(
                      fontSize: sizes.width * 0.03,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                width: sizes.width * 0.38,
                child: Text(
                  "Stock : ${datacheck[index].stock} ${datacheck[index].medida}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: sizes.width * 0.028,
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
              ),
              SizedBox(
                width: sizes.width * 0.38,
                child: Text(
                  "REF : ${datacheck[index].codigo}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: sizes.width * 0.028,
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: sizes.width * 0.01,
          ),
          SizedBox(
            child: Row(
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.article_outlined,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      size: 20,
                    ),
                    onPressed: () {
                      if (conexion.connectionType == 0) {
                        dialogointernet();
                      } else {
                        Navigator.pushNamed(context, "editaring",
                            arguments: datacheck[index]);
                      }
                    }),
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      size: 20,
                    ),
                    onPressed: () async {
                      if (conexion.connectionType == 0) {
                        dialogointernet();
                      } else {
                        final stock = int.parse(datacheck[index].stock);
                        if (stock == 0) {
                          dialogoborrar(datacheck[index].id);
                        } else {
                          dialogo(
                              "Debe dejar su Stock en 0 \nDirijase a inventario para realizar esta accion");
                        }
                      }
                    }),
              ],
            ),
          )
        ],
      ),
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

  stackloading() {
    return Stack(
      children: [
        (eliminando || consultando || restablecer)
            ? Scaffold(
                body: Container(
                  height: sizes.height,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              )
            : Container(),
        (eliminando || consultando || restablecer)
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
                        creando
                            ? Text(
                                "Creando insumo",
                                style: TextStyle(
                                    color: Color.fromRGBO(12, 60, 64, 1),
                                    fontWeight: FontWeight.w500),
                              )
                            : eliminando
                                ? Text(
                                    "Eliminando insumo",
                                    style: TextStyle(
                                        color: Color.fromRGBO(12, 60, 64, 1),
                                        fontWeight: FontWeight.w500),
                                  )
                                : consultando
                                    ? Text(
                                        "Consultando informacion",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(12, 60, 64, 1),
                                            fontWeight: FontWeight.w500),
                                      )
                                    : restablecer
                                        ? Text(
                                            "Restableciendo",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    12, 60, 64, 1),
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            "Editando insumo",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    12, 60, 64, 1),
                                                fontWeight: FontWeight.w500),
                                          )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.transparent),
                  height: sizes.height,
                ),
              )
            : Container()
      ],
    );
  }

  dialogoborrar(id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Text(
            "Borrar",
            style: TextStyle(
                color: Color.fromRGBO(12, 60, 64, 1),
                fontFamily: "evel",
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
          content: Text(
            "¿Esta seguro?",
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
                  if (conexion.connectionType == 0) {
                    dialogointernet();
                  } else {
                    Navigator.pop(context);
                    passpass(id);
                  }
                },
                child: Text("Si")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"))
          ],
        );
      },
    );
  }

  dialogo(texto) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Text(
            "Informacion",
            style: TextStyle(
                color: Color.fromRGBO(12, 60, 64, 1),
                fontFamily: "evel",
                fontSize: 15,
                fontWeight: FontWeight.w900),
          ),
          content: Text(
            texto,
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

  Future passpass(id) async {
    setState(() {
      consultando = true;
    });
    final pass = await provider.pass();
    setState(() {
      consultando = false;
    });
    var password = pass["password"];
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(12, 60, 64, 1),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: llavepass,
                  child: TextFormField(
                      controller: editorpass,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Texto vacio';
                        } else {
                          if (value != password) {
                            editorpass.clear();
                            return 'Contraseña incorrecta';
                          } else {
                            return null;
                          }
                        }
                      },
                      obscureText: true,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder())),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(12, 60, 64, 1),
                    ),
                  ),
                  onPressed: () async {
                    if (!llavepass.currentState!.validate()) return;
                    Navigator.pop(context);
                    editorpass.clear();
                    setState(() {
                      eliminando = true;
                    });
                    final h = await provider.borrarinsumo(id);
                    if (h == false) {
                      dialogointernet();
                      setState(() {
                      eliminando = false;
                    });
                    } else {
                      setState(() {
                      eliminando = false;
                    });
                    Controllerinsumos.to.actualizar();
                    }
                    
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

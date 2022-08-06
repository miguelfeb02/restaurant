// ignore_for_file:  prefer_const_constructors, avoid_print, use_key_in_widget_constructors, annotate_overrides, iterable_contains_unrelated_type, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';
import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/controllers/controllerpro.dart';

import 'package:restaurant/servicios/cmodel.dart';
import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/widgets.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  final provider = Providerx();

  final cmodel = Cmodel(nombre: '', id: "");
  final llave = GlobalKey<FormState>();
  final widgets = Widgets();
  var editando = false;
  var creando = false;
  var eliminando = false;
  var cantidad = 0;
  var restablecer = false;
  ScrollController control = ScrollController();
  TextEditingController editor = TextEditingController();
  final Controllercats data = Get.put(Controllercats());
  final Controllerpro datapro = Get.put(Controllerpro());
  final GetXNetworkManager conexion = Get.put(GetXNetworkManager());
  GlobalKey key = GlobalKey();
  final sizes = Get.size;
  List datacheck = [].obs;
  var editcat = false;
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (editando == false) {
          Navigator.pushNamed(context, "productos");
        }

        return false;
      },
      child: Stack(
        children: [
          Scaffold(
              drawer: widgets.drawer(context),
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.app_registration_sharp,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Categorías",
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
                              if (data.cats.isNotEmpty &&
                                  data.cats[0] == "error") {
                              } else {
                                editor.clear();
                                nuevacat();
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              body: Column(
                children: [Expanded(child: categorias()), cantidadcat()],
              )),
          stackloading()
        ],
      ),
    );
  }

  categorias() {
    final sizes = Get.size;
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: GetBuilder<Controllercats>(
        builder: (value) {
          List cats = value.cats;
          List catsx = cats.reversed.toList();
          if (value.cats.isNotEmpty && value.cats[0] == "error") {
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
              if (catsx.isNotEmpty) {
                return Scrollbar(
                  // controller: control,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: catsx.length,
                    itemBuilder: (BuildContext context, int index) {
                      return card(catsx, index);
                    },
                  ),
                );
              } else {
                return Center(
                    child: Text(
                  "No hay categorías creadas",
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
    List cantidades = cantproxcat();

    final Controllercats data = Get.put(Controllercats());
    final sizes = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  child: (index != null)
                      ? Text(
                          "${cantidades[index]} Productos",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: sizes.width * 0.03,
                            color: Color.fromRGBO(12, 60, 64, 1),
                          ),
                        )
                      : Text(
                          "0 Productos",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: sizes.width * 0.03,
                            color: Color.fromRGBO(12, 60, 64, 1),
                          ),
                        )),
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
                        editarcat(datacheck[index].id, datacheck[index].nombre);
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
                        if (cantidades[index] > 0) {
                          dialogo(
                              "Esta categoría contiene ${cantidades[index]} productos. \npara poder eleminarla, esta no debe tener productos creados");
                        } else {
                          dialogoborrar(datacheck[index].id);
                        }

                        setState(() {});
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  cantidadcat() {
    return Container(
      height: sizes.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<Controllercats>(
              init: Controllercats(),
              builder: (value) {
                return Text(
                  "Categorias : ${value.cantidad}",
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

  stackloading() {
    return Stack(
      children: [
        (editando || eliminando || creando || restablecer)
            ? Scaffold(
                body: Container(
                  height: sizes.height,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              )
            : Container(),
        (editando || eliminando || creando || restablecer)
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
                                "Creando categoria",
                                style: TextStyle(
                                    color: Color.fromRGBO(12, 60, 64, 1),
                                    fontWeight: FontWeight.w500),
                              )
                            : eliminando
                                ? Text(
                                    "Eliminando categoria",
                                    style: TextStyle(
                                        color: Color.fromRGBO(12, 60, 64, 1),
                                        fontWeight: FontWeight.w500),
                                  )
                                : restablecer
                                    ? Text(
                                        "Restableciendo conexion",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(12, 60, 64, 1),
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "Editando categoria",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(12, 60, 64, 1),
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

  cantproxcat() {
    Controllercats data = Get.put(Controllercats());

    List listprocat = [];
    for (var i = 0; i < data.cats.length; i++) {
      List cat = [];
      for (var j = 0; j < data.productos.length; j++) {
        if (data.cats[i].nombre == data.productos[j].cat) {
          cat.add("si");
        }
      }
      listprocat.add(cat.length);
    }

    return listprocat.reversed.toList();
  }

  Future nuevacat() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Nueva categoría',
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
                  key: llave,
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: editor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Texto vacio';
                        } else {
                          List igual = [];
                          for (var i = 0; i < data.cats.length; i++) {
                            if (data.cats[i].nombre ==
                                editor.text.toLowerCase()) {
                              igual.add(data.cats[i].nombre);
                            }
                          }
                          if (igual.isNotEmpty) {
                            return "Ya existe una categoria con este nombre";
                          } else {
                            return null;
                          }
                        }
                      },
                      onSaved: (value) {
                        cmodel.nombre = value!.toLowerCase();
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: InputDecoration(
                          labelText: "Nombre de categoría",
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
                    'Agregar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(12, 60, 64, 1),
                    ),
                  ),
                  onPressed: () async {
                    if (conexion.connectionType == 0) {
                      dialogointernet();
                    } else {
                      if (!llave.currentState!.validate()) return;
                      llave.currentState!.save();
                      Navigator.pop(context);
                      setState(() {
                        creando = true;
                      });
                      final creartrue = await provider.crearcat(cmodel);
                      setState(() {
                        creando = false;
                      });
                      if (creartrue) {
                        editor.clear();
                        Controllercats.to.actualizar();
                      }
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

  Future editarcat(idcat, cat) async {
    final sizes = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        editor.text = cat;
        return AlertDialog(
          title: const Text(
            'Editar categoría',
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
                  key: llave,
                  child: TextFormField(
                      controller: editor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Texto vacio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        cmodel.nombre = value!;
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: InputDecoration(
                          labelText: "Nombre de categoría",
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: sizes.width * 0.04,
                          ),
                          border: OutlineInputBorder())),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Tenga en cuenta que al editar la categoría, se editaran todos los productos con dicha categoría.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromRGBO(12, 60, 64, 1),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Editar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(12, 60, 64, 1),
                    ),
                  ),
                  onPressed: () async {
                    llave.currentState!.save();
                    if (!llave.currentState!.validate()) return;
                    Navigator.pop(context);
                    if (cmodel.nombre != cat) {
                      setState(() {
                        editando = true;
                      });

                      final edicion = await provider.editarcat(
                          cmodel, idcat, cat, cmodel.nombre);
                      if (edicion) {
                        setState(() {
                          editando = false;
                        });
                        Controllercats.to.actualizar();
                        Controllerpro.to.actualizar();
                      } else {
                        setState(() {
                          editando = false;
                        });
                        dialogointernet();
                      }
                      
                      editor.clear();
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
                  Navigator.pop(context);
                  setState(() {
                    eliminando = true;
                  });
                  await provider.borrarcat(id);
                  setState(() {
                    eliminando = false;
                  });
                  Controllercats.to.actualizar();
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

  loading() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            content: Center(
              child: SpinKitFadingCube(
                color: Color.fromRGBO(12, 60, 64, 1),
              ),
            ));
      },
    );
  }
}

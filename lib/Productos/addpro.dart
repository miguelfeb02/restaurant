// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print,
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';

import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';

import 'package:restaurant/controllers/controllerpro.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/cmodel.dart';
import 'package:restaurant/servicios/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/servicios/imodel.dart';

import 'package:restaurant/servicios/pmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class Addpro extends StatefulWidget {
  @override
  _AddproState createState() => _AddproState();
}

class _AddproState extends State<Addpro> {
  final provider = Providerx();
  final pre = PreferenciasUsuario();
  Pmodel pmodel = Pmodel(
      nombre: "",
      cat: "",
      precio: "",
      fotourl: "",
      stock: "",
      id: "",
      costetotal: "",
      tipo: false,
      colorimagen: false,
      color: "0",
      variantes: false);
  Imodel imodel = Imodel(
      nombre: "",
      cantidad: "",
      stock: "",
      id: "",
      idruta: "",
      medida: "",
      coste: "",
      codigo: "",
      costefinal: "0",
      costetotal: "",
      precio: "");

  bool colorfoto = false;
  int val = 1;
  var selectedcolor = 0;
  List colores = [
    Colors.grey,
    Colors.orange[900],
    Colors.red,
    Colors.lightGreen,
    Colors.purple,
    Colors.blue[700],
    Colors.green[900],
    Colors.indigo[900]
  ];
  List<String> unidad = ["Unidades", "gramos", "ml"];
  File foto = File("");
  var rutafoto = false;
  var valfoto = true;
  String urlfoto = "";
  var subiendo = false;
  var verificando = false;
  var tipopro = false;
  var variantes = false;
  var validator1 = false;
  var todosvalidos = false;
  var valbox = false;
  var valvarbox = false;
  var sum = 0;
  var move = false;
  var creandocat = false;
  var drop = false;
  var dropos = 0;
  var activetrue = false;
  var radioimagen = false;
  var radiocolor = true;

  var existeinfo1 = false;
  var existeinfo2 = false;
  var existeinfo3 = false;
  var existeinfo4 = false;
  var existeinfo5 = false;
  var existeinfo6 = false;
  var existeinfo7 = false;

  List usados = [];
  List usados2 = [];
  var dropvalue = "Sin categoria";
  final formKey = GlobalKey<FormState>();
  final llave = GlobalKey<FormState>();
  final llavex = GlobalKey<FormState>();
  final llavevariante = GlobalKey<FormState>();
  TextEditingController editorcat = TextEditingController();
  TextEditingController editor = TextEditingController();
  TextEditingController editorvariante = TextEditingController();
  TextEditingController editorx = TextEditingController();
  TextEditingController preciocontrol = TextEditingController();
  final Controllerpro data = Get.put(Controllerpro());
  final GetXNetworkManager conexion = Get.put(GetXNetworkManager());
  List<Imodel> zcomponentes = [];
  List<List<Imodel>> listavariantes = [];
  List listavargen = [];
  List<Imodel> listavariantesno = [];
  List nombrevariantesgen = [];
  List nombrevariantes = [];
  List nombrevariantesno = [];
  List<Imodel> pyc = [];
  ScrollController control = ScrollController();

  final CurrencyTextInputFormatter formatter =
      CurrencyTextInputFormatter(decimalDigits: 0, locale: "es", symbol: "");
  @override
  Widget build(BuildContext context) {
    if (tipopro) {
      listavargen = listavariantes;
      nombrevariantesgen = nombrevariantes;
    } else {
      listavargen = listavariantesno;
      nombrevariantesgen = nombrevariantesno;
    }
    final sizes = MediaQuery.of(context).size;
    if (foto.path != "") {
      rutafoto = true;
    } else {
      rutafoto = false;
    }

    List valboxitem = [];
    for (var i = 0; i < listavariantes.length; i++) {
      if (listavariantes[i].isEmpty) {
        valboxitem.add(true);
      } else {
        valboxitem.add(false);
      }
    }
    if (valboxitem.contains(true)) {
      todosvalidos = false;
    } else {
      todosvalidos = true;
    }
    return WillPopScope(
      onWillPop: () async {
        if (subiendo == false) {
          if (existeinfo1 ||
              existeinfo2 ||
              existeinfo3 ||
              existeinfo4 ||
              existeinfo5 ||
              existeinfo6 ||
              existeinfo7 ||
              rutafoto == true) {
            dialogo2actions();
          } else {
            Navigator.pop(context);
          }
        }

        return false;
      },
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                title: Text(
                  "Agregar producto",
                  style: TextStyle(fontSize: 16),
                ),
                centerTitle: true,
                elevation: 10,
              ),
              body: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Texto vacio";
                            } else {
                              if (value.startsWith(" ")) {
                                return "Existe un espacio en el primer Carácter";
                              } else {
                                List igual = [];
                                for (var i = 0;
                                    i < data.productos.length;
                                    i++) {
                                  if (data.productos[i].nombre ==
                                      value.toLowerCase()) {
                                    igual.add(data.productos[i].nombre);
                                  }
                                }

                                if (igual.isNotEmpty) {
                                  return "Ya existe un producto con este nombre";
                                } else {
                                  return null;
                                }
                              }
                            }
                          },
                          onChanged: (value) {
                            if (value != "") {
                              existeinfo1 = true;
                            } else {
                              existeinfo1 = false;
                            }
                          },
                          onSaved: (newValue) {
                            pmodel.nombre = newValue!.toLowerCase();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              label: Text("Nombre de producto"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GetBuilder<Controllercats>(builder: (value) {
                          List<String> da = [
                            "Sin categoria",
                            "Crear categoria"
                          ];
                          if (value.cats.isNotEmpty) {
                            for (var i = 0; i < value.cats.length; i++) {
                              da.add(value.cats[i].nombre);
                            }
                          }
                          return !value.creacat
                              ? DropdownButtonFormField(
                                  value: drop ? da.last : da[dropos],
                                  onSaved: (newValue) {
                                    pmodel.cat = newValue.toString();
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onChanged: (value) {
                                    dropvalue = value.toString();
                                    activetrue = true;
                                    if (value == "Crear categoria") {
                                      Controllercats.to.creacattrue();
                                      nuevacat();
                                      drop = true;
                                    }
                                    if (value != "Crear categoria") {
                                      for (var i = 0; i < da.length; i++) {
                                        if (da[i] == value) {
                                          dropos = i;
                                        }
                                      }
                                    }

                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (value != "Sin categoria") {
                                      existeinfo2 = true;
                                    } else {
                                      existeinfo2 = false;
                                    }
                                  },
                                  onTap: () {
                                    if (activetrue) {
                                      drop = true;
                                    }
                                  },
                                  validator: (value) {
                                    if (value == "Sin categoria") {
                                      return "Seleccione una categoria";
                                    } else {
                                      return null;
                                    }
                                  },
                                  items: da.map((String val) {
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
                                )
                              : Container(
                                  height: sizes.height * 0.061,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: value.loading
                                          ? SpinKitFadingCube(
                                              color:
                                                  Color.fromRGBO(12, 60, 64, 1),
                                              size: 10,
                                            )
                                          : Container()),
                                );
                        }),
                        SizedBox(
                          height: sizes.height * 0.025,
                        ),
                        Row(
                          children: [
                            SizedBox(width: sizes.width * 0.25),
                            SizedBox(
                                width: sizes.width * 0.35,
                                child: Text(
                                  "Producto compuesto",
                                  textAlign: TextAlign.right,
                                  style:
                                      TextStyle(fontSize: sizes.width * 0.035),
                                )),
                            Switch(
                              activeColor: Color.fromRGBO(12, 60, 64, 1),
                              value: tipopro,
                              onChanged: (value) {
                                setState(() {
                                  tipopro = value;
                                  pmodel.tipo = value;
                                  if (value == false) {
                                    variantes = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sizes.height * 0.005,
                        ),
                        tipopro
                            ? Row(
                                children: [
                                  SizedBox(width: sizes.width * 0.25),
                                  SizedBox(
                                      width: sizes.width * 0.35,
                                      child: Text(
                                        "Variantes",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: sizes.width * 0.035),
                                      )),
                                  Switch(
                                    activeColor: Color.fromRGBO(12, 60, 64, 1),
                                    value: variantes,
                                    onChanged: (value) {
                                      setState(() {
                                        variantes = value;
                                        pmodel.variantes = value;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: sizes.height * 0.02,
                        ),
                        !variantes
                            ? !tipopro
                                ? stockyprecio([])
                                : containerinsumos(
                                    zcomponentes, valboxitem, [], pmodel)
                            : containervariantes(valboxitem),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: ListTile(
                                title: Text("Color"),
                                leading: Radio(
                                  value: 1,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {
                                      pmodel.colorimagen = false;
                                      colorfoto = false;
                                      val = int.parse(value.toString());
                                    });
                                  },
                                  activeColor: Color.fromRGBO(12, 60, 64, 1),
                                ),
                              ),
                            ),
                            Flexible(
                              child: ListTile(
                                title: Text("Imagen"),
                                leading: Radio(
                                  value: 2,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {
                                      pmodel.colorimagen = true;
                                      colorfoto = true;
                                      val = int.parse(value.toString());
                                    });
                                  },
                                  activeColor: Color.fromRGBO(12, 60, 64, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        (colorfoto)
                            ? Container(
                                child: !rutafoto
                                    ? TextButton(
                                        child: Text(
                                          "Agregar Imagen",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(12, 60, 64, 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          fuente();
                                        },
                                      )
                                    : Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            fuente();
                                          }, // needed
                                          child: Image(
                                            image: FileImage(File(foto.path)),
                                          ),
                                        ),
                                      ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: valfoto
                                            ? Colors.transparent
                                            : Colors.red),
                                    color: Colors.blueGrey[100],
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                width: sizes.width * 0.9,
                              )
                            : GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: colores.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, childAspectRatio: 1),
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colores[index],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedcolor = index;
                                            pmodel.color = index.toString();
                                          });
                                        },
                                        child: Icon(
                                          Icons.done,
                                          color: (index == selectedcolor)
                                              ? Colors.white
                                              : colores[index],
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          width: sizes.width * 0.9,
                          child: MaterialButton(
                              child: Text(
                                "Agregar Producto",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromRGBO(12, 60, 64, 1),
                              onPressed: () async {
                                if (conexion.connectionType != 0) {
                                  if (tipopro && variantes == false) {
                                    if (zcomponentes.isEmpty) {
                                      setState(() {
                                        valbox = true;
                                      });
                                    } else {
                                      setState(() {
                                        valbox = false;
                                      });
                                    }
                                  }
                                  validator1 = true;
                                  if (variantes && tipopro) {
                                    if (listavariantes.isEmpty) {
                                      setState(() {
                                        valvarbox = true;
                                      });
                                    } else {
                                      setState(() {
                                        valvarbox = false;
                                      });
                                    }
                                  }
                                  if (colorfoto == false) {
                                    valfoto = true;
                                  } else {
                                    if (rutafoto) {
                                      setState(() {
                                        valfoto = true;
                                      });
                                    } else {
                                      setState(() {
                                        valfoto = false;
                                      });
                                    }
                                  }

                                  if (formKey.currentState!.validate() &&
                                      valfoto == true &&
                                      valbox == false &&
                                      Controllercats.to.creacat == false &&
                                      todosvalidos == true &&
                                      valvarbox == false) {
                                    formKey.currentState!.save();

                                    setState(() {
                                      verificando = true;
                                    });
                                    final internet = await provider.internet();
                                    setState(() {
                                      verificando = false;
                                    });
                                    if (internet) {
                                      setState(() {
                                      subiendo = true;
                                       });
                                      if (colorfoto) {
                                        final fototrue = await subirfoto1(foto);
                                        if (fototrue == true) {
                                          pmodel.fotourl = urlfoto;
                                          final protrue =
                                              await provider.crearproducto(
                                                  pmodel,
                                                  zcomponentes,
                                                  listavariantes,
                                                  nombrevariantes,
                                                  listavariantesno,
                                                  nombrevariantesno,
                                                  pyc);
                                          if (protrue) {
                                            setState(() {
                                              subiendo = false;
                                            });
                                            Navigator.pop(context);
                                            Controllerpro.to.actualizar();
                                            Controllercats.to.actualizar();
                                          }
                                        }
                                      } else {
                                        final protrue =
                                            await provider.crearproducto(
                                                pmodel,
                                                zcomponentes,
                                                listavariantes,
                                                nombrevariantes,
                                                listavariantesno,
                                                nombrevariantesno,
                                                pyc);
                                        if (protrue) {
                                          setState(() {
                                            subiendo = false;
                                          });
                                          Navigator.pop(context);
                                          Controllerpro.to.actualizar();
                                          Controllercats.to.actualizar();
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        verificando = false;
                                      });
                                      dialogointernet();
                                    }
                                  }
                                } else {
                                  dialogointernet();
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              )),
          subiendo || verificando
              ? Scaffold(
                  body: Container(
                    height: sizes.height,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                )
              : Container(),
          subiendo || verificando
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
                          subiendo
                              ? Text(
                                  "Creando Producto",
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 60, 64, 1),
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  "Verificando conexion",
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

  containervariantes(valboxitem) {
    if (nombrevariantesgen.isNotEmpty) {
      existeinfo7 = true;
    } else {
      existeinfo7 = false;
    }

    final sizes = MediaQuery.of(context).size;
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Variantes",
                style: TextStyle(
                    color: Color.fromRGBO(12, 60, 64, 1),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  width: sizes.height * 0.05,
                  height: sizes.width * 0.05,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      size: 20,
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      agregarvariante();
                    },
                  )),
            ],
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            child: (listavargen.isNotEmpty)
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listavargen.length,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text(
                                    "${nombrevariantesgen[index].toUpperCase()}",
                                    style: TextStyle(
                                        color: Color.fromRGBO(12, 60, 64, 1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    editarnombrevariante(
                                        nombrevariantesgen, index);
                                  },
                                ),
                                SizedBox(
                                    width: sizes.height * 0.05,
                                    height: sizes.width * 0.05,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Color.fromRGBO(12, 60, 64, 1),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (tipopro) {
                                          if (listavargen[index].isEmpty) {
                                            listavargen.removeAt(index);
                                            nombrevariantesgen.removeAt(index);
                                            setState(() {});
                                          } else {
                                            dialogoborrarvariante(index);
                                          }
                                        }
                                        // else {
                                        //   listavargen.removeAt(index);
                                        //   nombrevariantesgen.removeAt(index);
                                        //   setState(() {});
                                        // }
                                      },
                                    )),
                              ],
                            ),
                          ),
                          tipopro
                              ? containerinsumos(listavariantes[index],
                                  valboxitem[index], pyc[index], pmodel)
                              : Container(),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    },
                  )
                : SizedBox(
                    height: sizes.height * 0.055,
                    child: Center(
                      child: !valvarbox
                          ? Text(
                              "Presione  \"+\"  para agregar variantes",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : Text(
                              "No hay variantes agregadas",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                    ),
                  ),
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }

  Future agregarvariante() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            title: Text(
              'Nombre de Variante',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(12, 60, 64, 1),
              ),
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: llavevariante,
              child: TextFormField(
                  controller: editorvariante,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Texto vacio';
                    }
                    return null;
                  },
                  onSaved: (value) async {
                    List<Imodel> insumos = [];
                    Imodel imodel = Imodel(
                        precio: "",
                        codigo: "",
                        cantidad: "",
                        coste: "",
                        costefinal: "",
                        costetotal: "",
                        id: "",
                        idruta: "",
                        medida: "",
                        nombre: "",
                        stock: "");
                    if (tipopro) {
                      listavariantes.add(insumos);
                      nombrevariantes.add(value);
                      pyc.add(imodel);
                    } else {
                      listavariantesno.add(imodel);
                      nombrevariantesno.add(value);
                    }

                    setState(() {});
                  },
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(15),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Nombre de variante",
                      labelStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder())),
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
                      if (llavevariante.currentState!.validate()) {
                        llavevariante.currentState!.save();
                        editorvariante.clear();
                        Navigator.pop(context);
                        setState(() {});
                        validator1 = false;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  stockyprecio(componente) {
    final sizes = MediaQuery.of(context).size;
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Texto vacio";
              } else {
                return null;
              }
            },
            onChanged: (newValue) {
              if (variantes) {
                componente.stock = newValue;
              } else {
                pmodel.stock = newValue;
              }

              if (newValue != "") {
                existeinfo3 = true;
              } else {
                existeinfo3 = false;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(8),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                label: Text("Stock inicial"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
        SizedBox(
          width: sizes.width * 0.05,
        ),
        Flexible(
          child: TextFormField(
            controller: preciocontrol,
            validator: (value) {
              var newValue = value!.replaceAll(".", "");
              if (newValue.isEmpty) {
                return "Texto vacio";
              } else {
                var x = int.parse(newValue) + 0;
                if (x == 0) {
                  return "No puede ser 0 ";
                }
              }
            },
            onChanged: (newValue) {
              print(newValue);
              if (variantes) {
                componente.precio = newValue;
              } else {
                pmodel.precio = newValue;
              }

              if (newValue != "") {
                existeinfo4 = true;
              } else {
                existeinfo4 = false;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[formatter],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                label: Text("Precio"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        )
      ],
    );
  }

  containerinsumos(componentes, valor, pyc, pmodel) {
    if (componentes.isNotEmpty) {
      existeinfo6 = true;
    } else {
      existeinfo6 = false;
    }

    sum = 0;
    for (var i = 0; i < componentes.length; i++) {
      var newValue = componentes[i].costefinal.replaceAll(".", "");
      var e = int.parse(newValue);
      sum += e;
    }
    var sumx = formatter.format(sum.toString());
    bool valif = false;
    if (variantes && tipopro) {
      pyc.costefinal = sum.toString();
      if (validator1) {
        valif = valor;
      }
    } else {
      valif = valbox;
    }
    if (variantes == false && tipopro == true) {
      pmodel.costetotal = sum.toString();
    }
    final sizes = MediaQuery.of(context).size;
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            var newValue = value!.replaceAll(".", "");
            if (newValue.isEmpty) {
              return "Texto vacio";
            } else {
              var x = int.parse(newValue) + 0;
              if (x == 0) {
                return "No puede ser 0 ";
              }
            }
          },
          onChanged: (newValue) {
            if (variantes == false && tipopro) {
              pmodel.precio = newValue;
            }
            if (variantes && tipopro) {
              pyc.precio = newValue;
            }

            if (newValue != "") {
              existeinfo5 = true;
            } else {
              existeinfo5 = false;
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: <TextInputFormatter>[formatter],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              label: Text("Precio"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        SizedBox(
          height: sizes.height * 0.03,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: valif ? Colors.red : Colors.grey)),
          child: Column(
            children: [
              SizedBox(
                height: sizes.height * 0.015,
              ),
              Row(
                children: [
                  SizedBox(
                    width: sizes.width * 0.08,
                  ),
                  SizedBox(
                      child: Text(
                    "Insumo(C)",
                    style: TextStyle(
                        fontSize: sizes.width * 0.03,
                        color: Color.fromRGBO(12, 60, 64, 1),
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    width: sizes.width * 0.09,
                  ),
                  SizedBox(
                      child: Text(
                    "Cantidad",
                    style: TextStyle(
                        fontSize: sizes.width * 0.03,
                        color: Color.fromRGBO(12, 60, 64, 1),
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    width: sizes.width * 0.1,
                  ),
                  SizedBox(
                      child: Text(
                    "Coste",
                    style: TextStyle(
                        fontSize: sizes.width * 0.03,
                        color: Color.fromRGBO(12, 60, 64, 1),
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    width: sizes.width * 0.075,
                  ),
                  SizedBox(
                      width: sizes.height * 0.05,
                      height: sizes.width * 0.05,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.add_box_rounded,
                          color: Color.fromRGBO(12, 60, 64, 1),
                          size: 20,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          dialogoinsumos(componentes);
                        },
                      )),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                child: (componentes.isNotEmpty)
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: componentes.length,
                        itemBuilder: (BuildContext context, index) {
                          return insumoscard(componentes.reversed.toList(),
                              index, componentes);
                        },
                      )
                    : SizedBox(
                        height: sizes.height * 0.055,
                        child: Center(
                          child: !valif
                              ? Text(
                                  "Presione  \"+\"  para agregar insumos",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              : Text(
                                  "No hay insumos agregados",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                        ),
                      ),
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: sizes.height * 0.03,
                child: Row(
                  children: [
                    SizedBox(
                      width: sizes.width * 0.28,
                    ),
                    SizedBox(
                        child: Text(
                      "Coste Total",
                      style: TextStyle(
                          fontSize: sizes.width * 0.03,
                          color: Color.fromRGBO(12, 60, 64, 1),
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      width: sizes.width * 0.055,
                    ),
                    SizedBox(
                        width: sizes.width * 0.16,
                        child: Text(
                          sumx,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: sizes.width * 0.03,
                              color: Color.fromRGBO(12, 60, 64, 1),
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: sizes.height * 0.01,
              )
            ],
          ),
        ),
      ],
    );
  }

  insumoscard(data, index, componentes) {
    final sizes = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: sizes.height * 0.055,
          child: Row(
            children: [
              SizedBox(
                width: sizes.width * 0.04,
              ),
              SizedBox(
                  width: sizes.width * 0.22,
                  child: Text(
                    "${data[index].nombre} (${data[index].coste})",
                    style: TextStyle(fontSize: sizes.width * 0.03),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: sizes.width * 0.04,
              ),
              SizedBox(
                  width: sizes.width * 0.15,
                  child: Text(
                    "${data[index].cantidad}",
                    style: TextStyle(fontSize: sizes.width * 0.03),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: sizes.width * 0.04,
              ),
              SizedBox(
                  width: sizes.width * 0.16,
                  child: Text(
                    "${data[index].costefinal}",
                    style: TextStyle(fontSize: sizes.width * 0.03),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                width: sizes.width * 0.04,
              ),
              SizedBox(
                width: sizes.height * 0.05,
                height: sizes.width * 0.05,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.delete_forever,
                    color: Color.fromRGBO(12, 60, 64, 1),
                    size: 20,
                  ),
                  onPressed: () async {
                    final x = await pregunta(data, index, componentes);

                    componentes.removeAt(x[0]);
                    sum = 0;
                    for (var i = 0; i < componentes.length; i++) {
                      var e = int.parse(componentes[i].costefinal);
                      sum += e;
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  dialogoinsumos(componentes) {
    final sizes = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.all(10),
          content: SizedBox(
            height: sizes.height * 0.40,
            width: sizes.width * 0.6,
            child: GetBuilder<Controllerinsumos>(
              builder: (value) {
                List insumos = value.insumos;
                List insumosx = insumos.reversed.toList();
                if (insumosx.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                              width: sizes.width * 0.07,
                            ),
                            Text(
                              "Insumos",
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: sizes.width * 0.2,
                            ),
                            Text(
                              "Coste",
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: sizes.height * 0.25,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: insumosx.length,
                          itemBuilder: (BuildContext context, index) {
                            return dialogoinsumoscard(
                                insumosx, index, componentes);
                          },
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "adding");
                              },
                              child: Text(
                                "Crear insumos",
                                style: TextStyle(
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                ),
                              )),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(child: Text("No hay insumos creados"));
                }
              },
            ),
          ),
        );
      },
    );
  }

  dialogoinsumoscard(List data, index, componentes) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(20, 0, 29, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
          onTap: () async {
            final x = await pregunta(data, index, componentes);

            if (x.isEmpty) {
              cantidad(data, index, componentes);

              setState(() {});
            } else {
              Navigator.pop(context);
              dialogopop("Este insumo ya fue agregado");
            }
          },
          dense: true,
          trailing: Text(
            "${data[index].coste}",
            style: TextStyle(color: Color.fromRGBO(12, 60, 64, 1)),
          ),
          title: Text(
            "${data[index].nombre}",
            style: TextStyle(
              color: Color.fromRGBO(12, 60, 64, 1),
            ),
          )),
    );
  }

  Future<List> pregunta(data, index, componentes) async {
    List dir = [];
    for (var i = 0; i < componentes.length; i++) {
      if (componentes[i].id == data[index].id) {
        dir.add(i);
      }
    }
    return dir;
  }

  Future cantidad(data, index, componentes) async {
    String nombre = data[index].nombre.toString();
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            title: Text(
              'Cantidad de "$nombre"',
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
                        onSaved: (value) async {
                          Imodel imodel = Imodel(
                              nombre: "",
                              coste: "",
                              costefinal: "",
                              costetotal: "",
                              stock: "",
                              id: "",
                              idruta: "",
                              medida: "",
                              cantidad: "",
                              precio: "",
                              codigo: "");

                          var costeinsumo = int.parse(value.toString()) *
                              int.parse(data[index].coste);
                          imodel.coste = data[index].coste;
                          imodel.nombre = data[index].nombre;
                          imodel.cantidad = value.toString();
                          imodel.id = data[index].id;
                          imodel.codigo = data[index].codigo;
                          imodel.costefinal =
                              formatter.format(costeinsumo.toString());
                          componentes.add(imodel);
                          Navigator.pop(context);

                          sum = 0;
                          for (var i = 0; i < componentes.length; i++) {
                            var newValue =
                                componentes[i].costefinal.replaceAll(".", "");
                            var e = int.parse(newValue);
                            sum += e;
                          }
                          imodel.costetotal = formatter.format(sum.toString());
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Inserte Cantidad",
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
                      if (llave.currentState!.validate()) {
                        llave.currentState!.save();
                        editor.clear();
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future nuevacat() async {
    final Controllercats data = Get.put(Controllercats());

    Cmodel cat = Cmodel(nombre: "", id: "");

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Controllercats.to.creacatfalse();
            setState(() {
              drop = false;
            });

            Navigator.pop(context);
            return false;
          },
          child: AlertDialog(
            title: Text(
              'Nueva categoria',
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
                        controller: editorcat,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Texto vacio';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          cat.nombre = value!;
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(18),
                        ],
                        decoration: InputDecoration(
                            labelText: "Nombre de categoria",
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
                      List igual = [];

                      llave.currentState!.save();

                      for (var i = 0; i < data.cats.length; i++) {
                        if (data.cats[i].nombre == editorcat.text) {
                          igual.add(data.cats[i].nombre);
                        }
                      }
                      if (igual.isNotEmpty) {
                        dialogopop("Esta categoria ya existe");
                        editorcat.clear();
                      } else {
                        if (!llave.currentState!.validate()) return;

                        Navigator.pop(context);
                        Controllercats.to.creacattrue();
                        Controllercats.to.load(true);
                        final creartrue = await provider.crearcat(cat);

                        if (creartrue) {
                          await Controllercats.to.actualizar();
                          Controllercats.to.creacatfalse();
                          Controllercats.to.load(false);

                          editorcat.clear();

                          drop = true;
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future editarnombrevariante(nombres, index) async {
    editorx.text = nombres[index];
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Nombre variante',
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
                  key: llavex,
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: editorx,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Texto vacio';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          nombres[index] = value;
                        });
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: InputDecoration(
                          labelText: "Nombre de variante",
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
                    'Editar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(12, 60, 64, 1),
                    ),
                  ),
                  onPressed: () async {
                    if (!llavex.currentState!.validate()) return;
                    llavex.currentState!.save();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  fuente() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Text(
                  "Foto del producto",
                  style: TextStyle(
                    fontFamily: "evel",
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        FloatingActionButton(
                            backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                            heroTag: "b1",
                            child: Icon(
                              Icons.camera_alt,
                            ),
                            elevation: 10,
                            onPressed: () async {
                              tomarfoto();
                            }),
                        SizedBox(height: 10),
                        Text(
                          "Desde la camara",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "evel",
                            color: Color.fromRGBO(12, 60, 64, 1),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        FloatingActionButton(
                            backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                            heroTag: "b2",
                            child: Icon(
                              Icons.image,
                            ),
                            elevation: 10,
                            onPressed: () async {
                              seleccionarfoto();
                            }),
                        SizedBox(height: 10),
                        Text(
                          "Desde la galeria",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "evel",
                            color: Color.fromRGBO(12, 60, 64, 1),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  seleccionarfoto() async {
    Navigator.pop(context);
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      imageQuality: 30,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      foto = File(pickedFile.path);
      print(foto.path);
      setState(() {});
    }
  }

  tomarfoto() async {
    Navigator.pop(context);
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      imageQuality: 30,
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      foto = File(pickedFile.path);
      print(foto.path);
      setState(() {});
    }
  }

  Future<bool> subirfoto1(File imagen) async {
    String randon = randomNumeric(10);
    final storageReference =
        FirebaseStorage.instance.ref().child('images/$randon.jpg');
    await storageReference.putFile(imagen);

    final url = await storageReference.getDownloadURL();
    urlfoto = url;
    return true;
  }

  dialogopop(texto) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                    subiendo = false;
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          ),
        );
      },
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

  dialogoborrarvariante(index) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            title: Text(
              "Borrar Variante",
              style: TextStyle(
                  color: Color.fromRGBO(12, 60, 64, 1),
                  fontFamily: "evel",
                  fontSize: 15,
                  fontWeight: FontWeight.w900),
            ),
            content: Text(
              "Esta variante contiene insumos agregados \n¿Aun asi desear borrarla?",
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
                  onPressed: () {
                    listavariantes.removeAt(index);
                    nombrevariantes.removeAt(index);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Si")),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(12, 60, 64, 1),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
            ],
          ),
        );
      },
    );
  }

  dialogo2actions() {
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
            "¿Desea salir sin guradar los cambios?",
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
                  Navigator.pushNamed(context, "protabs");
                },
                child: Text("Salir")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Continuar"))
          ],
        );
      },
    );
  }
}

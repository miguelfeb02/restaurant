// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print,
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/controllers/controllerpro.dart';
import 'package:restaurant/preferencias/preferencias.dart';
import 'package:restaurant/servicios/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/servicios/imodel.dart';

import 'package:restaurant/servicios/pmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class Editarpro extends StatefulWidget {
  @override
  _EditarproState createState() => _EditarproState();
}

class _EditarproState extends State<Editarpro> {
  final provider = Providerx();
  Pmodel pmodel = Pmodel(
      nombre: "",
      cat: "",
      precio: "",
      fotourl: "",
      stock: "",
      id: "",
      costetotal: "",
      tipo: false,
      color: "0",
      colorimagen: false,
      variantes: false);

  Imodel imodel = Imodel(
      nombre: "",
      cantidad: "",
      stock: "",
      codigo: "",
      id: "",
      idruta: "",
      medida: "",
      coste: "",
      costefinal: "0",
      costetotal: "",
      precio: "");

  List<String> unidad = ["Unidades", "gramos", "ml"];
  File foto = File("");
  var rutafoto = false;

  String urlfoto = "";
  var subiendo = false;

  var validator1 = false;
  var valbox = false;
  var valvarbox = false;
  var sum = 0;
  var move = false;
  var valfoto = true;
  var select = false;
  var cambios = false;
  var cambiocat = false;
  var cambioseninsumos = false;

  bool colorfoto = false;
  int val = 1;
  var selectedcolor = 0;
  var editarcolorimagen = false;
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

  var existeinfo1 = false;
  var existeinfo2 = false;
  var existeinfo3 = false;
  var existeinfo4 = false;
  var existeinfo5 = false;
  var existeinfo6 = false;
  var existeinfo7 = false;

  final formKey = GlobalKey<FormState>();
  final llave = GlobalKey<FormState>();
  final llavex = GlobalKey<FormState>();
  final llavevariante = GlobalKey<FormState>();
  TextEditingController editor = TextEditingController();
  TextEditingController editorvariante = TextEditingController();
  TextEditingController editorx = TextEditingController();
  List zcomponentes = [];
  List listavariantes = [];
  List listavargen = [];
  List listavariantesno = [];
  List nombrevariantesgen = [];
  List nombrevariantes = [];
  List nombrevariantesno = [];
  var pyc = [];
  List valboxitem = [];

  ScrollController control = ScrollController();
  var todosvalidos = false;
  final pre = PreferenciasUsuario();
  final CurrencyTextInputFormatter formatter =
      CurrencyTextInputFormatter(decimalDigits: 0, locale: "es", symbol: "");
  @override
  Widget build(BuildContext context) {
    final prodatas = ModalRoute.of(context)!.settings.arguments as List;

    if (editarcolorimagen == false) {
      colorfoto = prodatas[0].colorimagen;
      selectedcolor = int.parse(prodatas[0].color);
      if (colorfoto) {
        val = 2;
      } else {
        val = 1;
      }
    }

    if (prodatas[0].variantes && prodatas[0].tipo) {
      nombrevariantes = prodatas[1][0];
      listavariantes = prodatas[1][2];
      listavargen = listavariantes;
      nombrevariantesgen = nombrevariantes;
      pyc = prodatas[1][1];
    }

    if (prodatas[0].variantes == false && prodatas[0].tipo) {
      zcomponentes = prodatas[1][2];
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
          if (cambios) {
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
                  "Editar producto",
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
                          initialValue: prodatas[0].nombre,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Texto vacio";
                            } else {
                              if (value.startsWith(" ")) {
                                return "Existe un espacio en el primer Carácter";
                              } else {
                                return null;
                              }
                            }
                          },
                          onSaved: (newValue) {
                            prodatas[0].nombre = newValue!;
                          },
                          onChanged: (value) {
                            cambios = true;
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
                          List<String> da = [];
                          if (value.cats.isNotEmpty) {
                            for (var i = 0; i < value.cats.length; i++) {
                              da.add(value.cats[i].nombre);
                            }
                          }
                          return DropdownButtonFormField(
                            value: prodatas[0].cat,
                            onSaved: (newValue) {
                              prodatas[0].cat = newValue.toString();
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null) {
                                return "Seleccione una categoria";
                              } else {
                                return null;
                              }
                            },
                            hint: Text("Eliga una categoria"),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                cambios = true;
                                cambiocat = true;
                              });
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
                          );
                        }),
                        SizedBox(
                          height: sizes.height * 0.02,
                        ),
                        SizedBox(
                          height: sizes.height * 0.02,
                        ),
                        prodatas[0].variantes == false && prodatas[0].tipo
                            ? TextFormField(
                                initialValue: prodatas[0].precio,
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
                                onChanged: (value) {
                                  setState(() {
                                    cambios = true;
                                  });
                                },
                                onSaved: (newValue) {
                                  prodatas[0].precio = newValue.toString();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: <TextInputFormatter>[
                                  formatter
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    label: Text("Precio"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              )
                            : SizedBox(),
                        !prodatas[0].variantes
                            ? !prodatas[0].tipo
                                ? stockyprecio(prodatas[0])
                                : containerinsumos(
                                    prodatas[0], zcomponentes, valboxitem, [])
                            : containervariantes(valboxitem, pyc, prodatas[0]),
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
                                      cambios = true;
                                      editarcolorimagen = true;
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
                                      cambios = true;
                                      editarcolorimagen = true;
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
                        SizedBox(
                          height: 20,
                        ),
                        (colorfoto)
                            ? Container(
                                child: prodatas[0].colorimagen == false
                                    ? rutafoto
                                        ? Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                fuente();
                                              }, // needed
                                              child: Image(
                                                image:
                                                    FileImage(File(foto.path)),
                                              ),
                                            ),
                                          )
                                        : TextButton(
                                            child: Text(
                                              "Agregar Imagen",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    12, 60, 64, 1),
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
                                              image: CachedNetworkImageProvider(
                                                  prodatas[0].fotourl)),
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
                                            cambios = true;
                                            editarcolorimagen = true;
                                            selectedcolor = index;
                                            prodatas[0].color =
                                                index.toString();
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
                              child: cambios
                                  ? Text(
                                      "Aplicar cambios",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      "Editar Producto",
                                      style: TextStyle(color: Colors.white),
                                    ),
                              color: Color.fromRGBO(12, 60, 64, 1),
                              onPressed: () async {
                                if (prodatas[0].tipo &&
                                    prodatas[0].variantes == false) {
                                  if (zcomponentes.isEmpty) {
                                    valbox = true;
                                  } else {
                                    valbox = false;
                                  }
                                }
                                validator1 = true;
                                setState(() {});
                                if ((prodatas[0].variantes &&
                                        prodatas[0].tipo) ||
                                    (prodatas[0].variantes &&
                                        prodatas[0].tipo == false)) {
                                  if (listavargen.isEmpty) {
                                    valvarbox = true;
                                  } else {
                                    valvarbox = false;
                                  }
                                }

                                if (colorfoto == false) {
                                  valfoto = true;
                                } else {
                                  if (rutafoto || prodatas[0].fotourl != "") {
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
                                    todosvalidos &&
                                    valvarbox == false) {
                                  formKey.currentState!.save();
                                  setState(() {
                                    subiendo = true;
                                  });
                                  if ((rutafoto || prodatas[0].fotourl != "") &&
                                      colorfoto) {
                                    if (rutafoto) {
                                      final fototrue = await subirfoto1(foto);
                                      if (fototrue == true) {
                                        prodatas[0].fotourl = urlfoto;
                                        prodatas[0].color = 0.toString();
                                        prodatas[0].colorimagen = true;
                                        final editprotrue =
                                            await provider.editarprodcuto(
                                          prodatas[0],
                                          zcomponentes,
                                          listavariantes,
                                          nombrevariantes,
                                          listavariantesno,
                                          nombrevariantesno,
                                          pyc,
                                        );
                                        if (editprotrue) {
                                          subiendo = false;
                                          Navigator.pop(context);
                                          Controllerpro.to.actualizar();
                                        }
                                      }
                                    } else {
                                       
                                        prodatas[0].color = 0.toString();
                                        prodatas[0].colorimagen = true;
                                        final editprotrue =
                                            await provider.editarprodcuto(
                                          prodatas[0],
                                          zcomponentes,
                                          listavariantes,
                                          nombrevariantes,
                                          listavariantesno,
                                          nombrevariantesno,
                                          pyc,
                                        );
                                        if (editprotrue) {
                                          subiendo = false;
                                          Navigator.pop(context);
                                          Controllerpro.to.actualizar();
                                        }
                                    }
                                  } else {
                                    prodatas[0].fotourl = "";

                                    prodatas[0].colorimagen = false;
                                    final editprotrue =
                                        await provider.editarprodcuto(
                                      prodatas[0],
                                      zcomponentes,
                                      listavariantes,
                                      nombrevariantes,
                                      listavariantesno,
                                      nombrevariantesno,
                                      pyc,
                                    );
                                    if (editprotrue) {
                                      subiendo = false;
                                      Navigator.pop(context);
                                      Controllerpro.to.actualizar();
                                    }
                                  }
                                }
                              }),
                        )
                      ],
                    ),
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
                            "Editando Producto",
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

  containervariantes(valboxitem, precios, prodatas) {
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
                      agregarvariante(prodatas);
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

                                        if (nombrevariantesgen[index].isEmpty ||
                                            prodatas.tipo == false) {
                                          listavargen.removeAt(index);
                                          nombrevariantesgen.removeAt(index);
                                          setState(() {
                                            cambios = true;
                                          });
                                        } else {
                                          dialogoborrarvariante(index);
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
                          prodatas.tipo
                              ? containerinsumos(
                                  prodatas,
                                  listavariantes[index],
                                  valboxitem[index],
                                  precios[index],
                                )
                              : stockypreciolista(listavariantesno[index]),
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

  Future agregarvariante(prodatas) async {
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
                    Imodel vmodel = Imodel(
                        cantidad: "",
                        coste: "",
                        codigo: "",
                        costefinal: "",
                        costetotal: "",
                        id: "",
                        idruta: "",
                        medida: "",
                        nombre: "",
                        precio: "",
                        stock: "");
                    if (prodatas.tipo) {
                      listavariantes.add(insumos);
                      nombrevariantes.add(value);
                      pyc.add(vmodel);
                    } else {
                      listavariantesno.add(vmodel);
                      nombrevariantesno.add(value);
                    }

                    setState(() {
                      cambios = true;
                    });
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

  stockyprecio(prodata) {
    final sizes = MediaQuery.of(context).size;
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            initialValue: prodata.stock,
            enabled: false,
            validator: (value) {
              if (value!.isEmpty) {
                return "Texto vacio";
              } else {
                return null;
              }
            },
            onChanged: (newValue) {},
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
            initialValue: prodata.precio,
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
              prodata.precio = newValue;
              setState(() {
                cambios = true;
              });
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(8),
              formatter
            ],
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

  stockypreciolista(componente) {
    final sizes = MediaQuery.of(context).size;
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            initialValue: componente.stock,
            validator: (value) {
              if (value!.isEmpty) {
                return "Texto vacio";
              } else {
                return null;
              }
            },
            enableInteractiveSelection: false,
            onChanged: (newValue) {
              componente.stock = newValue;
              setState(() {
                cambios = true;
              });
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
                label: Text("Stock"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
        SizedBox(
          width: sizes.width * 0.05,
        ),
        Flexible(
          child: TextFormField(
            initialValue: componente.precio,
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
            onChanged: (newValue) {
              componente.precio = newValue;
              setState(() {
                cambios = true;
              });
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
                label: Text("Precio"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        )
      ],
    );
  }

  containerinsumos(prodatas, componentes, valor, pyc) {
    sum = 0;
    for (var i = 0; i < componentes.length; i++) {
      var newValue = componentes[i].costefinal.replaceAll(".", "");
      var e = int.parse(newValue);
      sum += e;
    }
    var sumx = formatter.format(sum.toString());
    bool valif = false;
    if (prodatas.variantes && prodatas.tipo) {
      pyc.costefinal = sum.toString();
      if (validator1) {
        valif = valor;
      }
    } else {
      valif = valbox;
    }
    if (prodatas.variantes == false && prodatas.tipo == true) {
      prodatas.costetotal = sum.toString();
    }
    final sizes = MediaQuery.of(context).size;
    return Column(
      children: [
        prodatas.variantes && prodatas.tipo
            ? TextFormField(
                initialValue: pyc.precio,
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
                  pyc.precio = newValue;
                  setState(() {
                    cambios = true;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(8),
                  formatter
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    label: Text("Precio"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
            : Container(),
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

  insumoscard(data, index, List componentes) {
    Controllerinsumos info = Get.put(Controllerinsumos());
    String nombre =
        "(No existe)\n ref : ${data[index].codigo} \n ${data[index].nombre} ";
    for (var i = 0; i < info.insumos.length; i++) {
      if (data[index].id == info.insumos[i].id) {
        nombre = "${info.insumos[i].nombre} (${info.insumos[i].coste})";
      }
    }

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
                    nombre,
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
                      var newValue =
                                componentes[i].costefinal.replaceAll(".", "");
                            var e = int.parse(newValue);
                      sum += e;
                    }
                    setState(() {
                      cambios = true;
                    });
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
              cantidad(data, index, data[index].nombre.toString(), componentes);

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

  Future cantidad(data, index, nombre, componentes) async {
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
                          imodel.nombre = data[index].nombre;
                          imodel.cantidad = value.toString();
                          imodel.id = data[index].id;
                          imodel.codigo = data[index].codigo;

                          imodel.costefinal = formatter.format(costeinsumo.toString());
                          componentes.add(imodel);
                          Navigator.pop(context);

                          sum = 0;
                          for (var i = 0; i < componentes.length; i++) {
                            var newValue =
                                componentes[i].costefinal.replaceAll(".", "");
                            var e = int.parse(newValue);
                            sum += e;
                          }
                          pmodel.costetotal = sum.toString();
                          setState(() {
                            cambios = true;
                          });
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
                    setState(() {
                      cambios = true;
                    });
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
}

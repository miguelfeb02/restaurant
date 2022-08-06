// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables,, sized_box_for_whitespace, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';
import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/controllers/controllerpro.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/imodel.dart';

import 'package:restaurant/servicios/widgets.dart';
import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/pmodel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Productos extends StatefulWidget {
  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final provider = Providerx();
  final widgets = Widgets();
  final pre = PreferenciasUsuario();
  Pmodel pmodel = Pmodel(
      nombre: "",
      cat: "",
      color: "",
      fotourl: "",
      precio: "",
      costetotal: "",
      stock: "",
      id: "",
      tipo: false,
      colorimagen: false,
      variantes: false);
  Imodel imodel = Imodel(
      nombre: "",
      cantidad: "",
      codigo: "",
      costefinal: "",
      costetotal: "",
      stock: "",
      id: "",
      idruta: "",
      coste: "",
      medida: "",
      precio: "");
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
  String texto = "";
  List productoslista = [];
  int init = 0;
  var initstring = "Todas las categorias";
  var carvar = false;
  var eliminando = false;
  var busqueda = true;
  var sizes = Get.size;
  var restablecer = false;
  final Controllerpro dataconteo = Get.put(Controllerpro());
  final GetXNetworkManager conexion = Get.put(GetXNetworkManager());
  var cantidad = 0;
  ScrollController control = ScrollController();
  TextEditingController busquedacontrol = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          !carvar
              ? Scaffold(
                  drawer: widgets.drawer(context),
                  appBar: AppBar(
                    backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_business_rounded,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Productos",
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
                                  if (dataconteo.productos.isNotEmpty &&
                                      dataconteo.productos[0] == "error") {
                                  } else {
                                    Navigator.pushNamed(context, "addpro")
                                        .whenComplete(() => setState(() {
                                              busqueda = true;
                                            }));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  body: busqueda
                      ? Column(
                          children: [
                            Row(
                              children: [
                                GetBuilder<Controllercats>(
                                  builder: (value) {
                                    return Expanded(child: listacategorias());
                                  },
                                ),
                                botonbusqueda()
                              ],
                            ),
                            GetBuilder<Controllerpro>(
                              builder: (value) {
                                return Expanded(child: listaproductos());
                              },
                            ),
                            cantidadproductos()
                          ],
                        )
                      : listabusqueda())
              : Container(),
          stackloading()
        ],
      ),
    );
  }

  stackloading() {
    return Stack(
      children: [
        (carvar || eliminando || restablecer)
            ? Container(
                height: sizes.height,
                decoration: BoxDecoration(color: Colors.white),
              )
            : Container(),
        (carvar || eliminando || restablecer)
            ? Container(
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
                      eliminando
                          ? Text(
                              "Borrando Producto",
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                  fontWeight: FontWeight.w500),
                            )
                          : restablecer
                              ? Text(
                                  "Restableciendo",
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 60, 64, 1),
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  "Obteniendo Informacion",
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 60, 64, 1),
                                      fontWeight: FontWeight.w500),
                                )
                    ],
                  ),
                ),
                height: sizes.height,
                decoration: BoxDecoration(color: Colors.transparent),
              )
            : Container(),
      ],
    );
  }

  listabusqueda() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                flex: 7,
                child: TextField(
                  controller: busquedacontrol,
                  onChanged: (value) {
                    setState(() {
                      texto = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                )),
            Flexible(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey))),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    busqueda = !busqueda;
                    texto = "";
                    busquedacontrol.clear();
                  });
                },
                color: Color.fromRGBO(12, 60, 64, 1),
                icon: Icon(Icons.disabled_by_default_rounded),
              ),
            ))
          ],
        ),
        Expanded(child: listaproductosfilter(texto))
      ],
    );
  }

  botonbusqueda() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey))),
      child: IconButton(
        onPressed: () {
          if (conexion.connectionType != 0) {
            setState(() {
              busqueda = !busqueda;
            });
          }
        },
        color: Color.fromRGBO(12, 60, 64, 1),
        icon: Icon(Icons.search),
      ),
    );
  }

  cantidadproductos() {
    return Container(
      height: sizes.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<Controllerpro>(
              init: Controllerpro(),
              builder: (value) {
                return (initstring == "Todas las categorias")
                    ? Text(
                        "Productos : ${value.cantidad}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(12, 60, 64, 1),
                        ),
                      )
                    : Text(
                        "Productos : $cantidad",
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

  listacategorias() {
    
    return GetBuilder<Controllercats>(builder: (value) {
      List<String> da = ["Todas las categorias"];
      if (value.cats.isNotEmpty && value.cats[0] == "error") {
        return TextField(
          enabled: false,
        );
      } else {
        if (value.cats.isNotEmpty) {
          for (var i = 0; i < value.cats.length; i++) {
            da.add(value.cats[i].nombre);
          }
          return DropdownButtonFormField(
            dropdownColor: Colors.white,
            focusColor: Color.fromRGBO(12, 60, 64, 1),
            value: da[0],
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onChanged: (newValue) {
              initstring = newValue.toString();
              List conteo = [];
              for (var i = 0; i < dataconteo.productos.length; i++) {
                if (dataconteo.productos[i].cat == newValue) {
                  conteo.add(1);
                }
              }

              setState(() {
                if (newValue == "Todas las categorias") {
                  cantidad = dataconteo.productos.length;
                } else {
                  cantidad = conteo.length;
                }

                pre.valcat = newValue.toString();
                for (var i = 0; i < da.length; i++) {
                  if (newValue == da[i]) {
                    init = i;
                  }
                }
              });
            },
            items: da.map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                  style: TextStyle(
                      color: Color.fromRGBO(12, 60, 64, 1),
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          );
        } else {
          return TextField(
            enabled: false,
          );
        }
      }
    });
  }

  listaproductosfilter(texto) {
    if (texto == "") {
      texto = " ";
    } else {
      texto = texto;
    }
    final sizes = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: 0),
        child: GetBuilder<Controllerpro>(
          builder: (value) {
            if (value.esperando) {
              List productos = value.productos;

              List filter = productos.where((valor) {
                return valor.nombre
                    .toLowerCase()
                    .startsWith(texto.toLowerCase());
              }).toList();
              List productosx = filter.reversed.toList();
              if (productosx.isNotEmpty) {
                return Scrollbar(
                  child: ListView.builder(
                    controller: control,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: productosx.length,
                    itemBuilder: (BuildContext context, int index) {
                      return card(productosx, index, productos);
                    },
                  ),
                );
              } else {
                return (texto != " " && productosx.isEmpty)
                    ? Center(
                        child: Text(
                        "No hay coincidencias",
                        style: TextStyle(
                          color: Color.fromRGBO(12, 60, 64, 1),
                        ),
                      ))
                    : Center(
                        child: Text(
                        "Realice su busqueda",
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
              ));
            }
          },
        ));
  }

  listaproductos() {
    final sizes = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: 0),
        child: GetBuilder<Controllerpro>(
          builder: (value) {
            if (value.productos.isNotEmpty && value.productos[0] == "error") {
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
                List productos = value.productos;
                List productosx = productos.reversed.toList();
                if (productosx.isNotEmpty) {
                  List listaxcat = organizadorcats();
                  List vista = [productosx];

                  for (var i = 0; i < listaxcat.length; i++) {
                    vista.add(listaxcat[i]);
                  }

                  return Scrollbar(
                    child: ListView.builder(
                      controller: control,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: vista[init].length,
                      itemBuilder: (BuildContext context, int index) {
                        cantidad = vista[init].length;
                        return card(vista[init], index, productos);
                      },
                    ),
                  );
                } else {
                  return Center(
                      child: Text(
                    "No hay productos creados",
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
                ));
              }
            }
          },
        ));
  }

  card(data, index, productos) {
    final sizes = MediaQuery.of(context).size;
    return Container(
      height: sizes.height * 0.082,
      margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          SizedBox(
              width: sizes.width * 0.12,
              child: data[index].colorimagen
                  ? CircleAvatar(
                      radius: 25,
                      backgroundColor: Color.fromRGBO(12, 60, 64, 1),
                      backgroundImage:
                          CachedNetworkImageProvider(data[index].fotourl))
                  : CircleAvatar(
                      radius: 25,
                      backgroundColor: colores[int.parse(data[index].color)])),
          SizedBox(
            width: sizes.width * 0.05,
          ),
          SizedBox(
            width: sizes.width * 0.40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data[index].nombre.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Categoria : ${data[index].cat}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color.fromRGBO(12, 60, 64, 1),
                  ),
                ),
                (data[index].variantes && data[index].tipo)
                    ? Text(
                        "Variante y compuesto",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Color.fromRGBO(12, 60, 64, 1),
                        ),
                      )
                    : (data[index].variantes && data[index].tipo == false)
                        ? Text(
                            "Variante",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Color.fromRGBO(12, 60, 64, 1),
                            ),
                          )
                        : (data[index].variantes == false && data[index].tipo)
                            ? Text(
                                "Compuesto",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                ),
                              )
                            : Text(
                                "Precio : \$ ${data[index].precio}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromRGBO(12, 60, 64, 1),
                                ),
                              )
              ],
            ),
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
                      size: 28,
                    ),
                    onPressed: () async {
                      if (conexion.connectionType == 0) {
                        dialogointernet();
                      } else {
                        if (data[index].tipo || data[index].variantes) {
                          setState(() {
                          carvar = true;
                        });
                        }

                        final anexos =
                            await provider.cargarvariantes(data[index]);

                        if (anexos.isNotEmpty && anexos[0] == "error") {
                          dialogointernet();
                          setState(() {
                            carvar = false;
                          });
                        } else {
                          Navigator.pushNamed(context, "editarpro",
                                  arguments: [data[index], anexos])
                              .whenComplete(() => setState(() {
                                    carvar = false;
                                  }));
                        }
                      }
                    }),
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Color.fromRGBO(12, 60, 64, 1),
                      size: 28,
                    ),
                    onPressed: () {
                      if (conexion.connectionType == 0) {
                        dialogointernet();
                      } else {
                        dialogodelete(data[index], productos);
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  dialogodelete(data, List productos) {
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
            "¿Esta seguro? \n Esto afectara el inventario...",
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
                  final h = await provider.borrarproducto(data.id);
                  if (h == false) {
                    dialogointernet();
                    setState(() {
                      eliminando = false;
                    });
                  } else {
                    setState(() {
                      eliminando = false;
                    });
                    Controllerpro.to.actualizar();
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

  organizadorcats() {
    Controllerpro pro = Get.put(Controllerpro());
    Controllercats cats = Get.put(Controllercats());
    // List catsx = cats.cats.reversed.toList();
    // ;
    List prox = pro.productos.reversed.toList();
    List listaorg = [];
    for (var i = 0; i < cats.cats.length; i++) {
      List temp = [];
      for (var j = 0; j < prox.length; j++) {
        if (prox[j].cat == cats.cats[i].nombre) {
          temp.add(prox[j]);
        }
      }
      listaorg.add(temp);
    }

    return listaorg;
  }
}

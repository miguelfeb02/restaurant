// ignore_for_file: must_call_super, avoid_print

import 'package:get/get.dart';
import 'package:restaurant/servicios/firebase.dart';

class Controllercats extends GetxController {
  static Controllercats get to => Get.find();
  var provider = Providerx();
  List cats = [];
  List productos = [];
  int cantidad = 0;
  var creacat = false;
  var loading = false;
  var esperando = false;

  @override
  void onInit() async {
    cats = await provider.cargarcats();
    productos = await provider.cargarproductos();
    cantidad = cats.length;
    update();
    esperando = true;
  }

  actualizar() async {
    cats = await provider.cargarcats();
    productos = await provider.cargarproductos();
    cantidad = cats.length;
    update();
  }

  void creacattrue() async {
    creacat = true;
    update();
  }

  void creacatfalse() async {
    creacat = false;
    update();
  }

  void load(bool valor) async {
    loading = valor;
    update();
  }
}

// ignore_for_file: must_call_super, avoid_print

import 'package:get/get.dart';
import 'package:restaurant/servicios/firebase.dart';

class Controllerpro extends GetxController {
  static Controllerpro get to => Get.find();
  var provider = Providerx();
  List productos = [];
  var cantidad = 0;
  
  var esperando = false;
  @override
  void onInit() async {
    productos = await provider.cargarproductos();
    cantidad = productos.length;
    update();
    esperando = true;
  }

   actualizar() async {
    productos = await provider.cargarproductos();
    cantidad = productos.length;
    update();
  }

  
}

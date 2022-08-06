// ignore_for_file: must_call_super, avoid_print

import 'package:get/get.dart';
import 'package:restaurant/servicios/firebase.dart';

class Controllerinsumos extends GetxController {
  static Controllerinsumos get to => Get.find();
  var provider = Providerx();
  List insumos = [];
  List variantes = [];
  var cantidad = 0;
  var esperando = false;
  var actual = false;
  var ref = "";
  @override
  void onInit() async {
    final refa = await provider.pass();
    ref = refa["ref"].toString();
    insumos = await provider.cargarinsumos();
    cantidad = insumos.length;
    update();
    esperando = true;
  }

  actualizar() async {
    insumos = await provider.cargarinsumos();
    cantidad = insumos.length;
    update();
  }

  void actualtrue() async {
    actual = true;
    update();
  }

  void actualfalse() async {
    actual = false;
    update();
  }
   actualizaref() async {
    final refa = await provider.pass();
    ref = refa["ref"].toString();
    update();
  }
}

// ignore_for_file: must_call_super, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GetXNetworkManager extends GetxController {
  int connectionType = 0;
  var internet = false;
  var count = 0;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;
  final String url = 'https://restaurant-8c6b0-default-rtdb.firebaseio.com/';
  @override
  void onInit() {
    GetConnectionType();
    streamSubscription = connectivity.onConnectivityChanged.listen(updateState);
  }

  Future<void> GetConnectionType() async {
    var connectivityResult;
    try {
      connectivityResult = await (connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      print(e);
    }
    return updateState(connectivityResult);
  }

  updateState(ConnectivityResult result) async {
    count++;

    try {
      await InternetAddress.lookup('google.com');
      internet = true;
    } catch (e) {
      internet = false;
      count = 3;
    }
    print("internet $internet");
    print("count $count");
    switch (result) {
      case ConnectivityResult.wifi:
      if (internet) {
        connectionType = 1;
        update();

        if (count > 2) {
          Get.snackbar("Estado de red", "Se restauro la conexión a internet",
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              icon: Icon(
                Icons.wifi,
                color: Colors.white,
              ));
        }
      }
        

        break;
      case ConnectivityResult.mobile :
          if (internet) {
        connectionType = 2;
        update();

        if (count > 2) {
          Get.snackbar("Estado de red", "Se restauro la conexión a internet",
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              icon: Icon(
                Icons.wifi,
                color: Colors.white,
              ));
        }
      }

        break;
      case ConnectivityResult.none:
        connectionType = 0;
        update();

        if (count > 2) {
          Get.snackbar("Estado de red", "En este momento no tienes conexión",
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              icon: Icon(
                Icons.wifi_off,
                color: Colors.white,
              ));
        }

        break;
      default:
        break;
    }
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }
}

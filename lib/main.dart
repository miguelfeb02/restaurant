// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:restaurant/Productos/addins.dart';
import 'package:restaurant/Productos/editarins.dart';

import 'package:restaurant/Productos/protabs.dart';



import 'package:restaurant/controllers/enlace.dart';

import 'package:restaurant/inventario/invtabs.dart';
import 'package:restaurant/Productos/addpro.dart';

import 'package:restaurant/Productos/editarpro.dart';

import 'package:restaurant/pages/ventas.dart';
import 'package:restaurant/preferencias/preferencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( );
  
  await PreferenciasUsuario().initPrefs();
  


  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
                  return GetMaterialApp(
                        initialBinding: NBinding(),
                        theme: ThemeData(
                            colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.blueGrey,
                        )),
                        debugShowCheckedModeBanner: false,

                        title: 'Material App',
                        initialRoute: "protabs",
                        routes: {
                          "addpro": (context) => Addpro(),
                          "adding": (context) => Addins(),
                          "editarpro": (context) => Editarpro(),
                          "editaring": (context) => Editarins(),
                          "invtabs": (context) => Invtabs(),
                          "ventas": (context) => Ventas(),
                          "protabs": (context) => Protabs(),
                        },
                      );
                    }
           
      
  }


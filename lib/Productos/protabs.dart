// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:restaurant/Productos/categorias.dart';
import 'package:restaurant/Productos/insumos.dart';
import 'package:restaurant/Productos/productos.dart';
import 'package:restaurant/preferencias/preferencias.dart';

import 'package:restaurant/servicios/widgets.dart';

class Protabs extends StatefulWidget {
  @override
  _ProtabsState createState() => _ProtabsState();
}

class _ProtabsState extends State<Protabs> {
  final pre = PreferenciasUsuario();

  final widgetsx = Widgets();

 

  List<Widget> tabs = <Widget>[
    Productos(),
    Insumos(),
    Categorias(),
  ];

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      body: IndexedStack(
        index: pre.tab,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_business_rounded,
            ),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_link_rounded,
            ),
            label: 'Insumos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.app_registration_sharp,
            ),
            label: 'Categorias',
          ),
        ],
        currentIndex: pre.tab,
        selectedItemColor: Color.fromRGBO(12, 60, 64, 1),
        onTap: (value) {
          setState(() {
            pre.tab = value;
          });
        },
      ),
    );
  }
}

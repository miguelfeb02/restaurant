// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Widgets extends StatelessWidget {
  drawer(context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                  color: Color.fromRGBO(12, 60, 64, 1),
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 12,
                          left: 16,
                          child: Text(
                            "Configuracion",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  ))),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "protabs");
            },
            leading: Icon(
              Icons.add_business_rounded,
              color: Color.fromRGBO(12, 60, 64, 1),
            ),
            title: Text(
              "Productos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 60, 64, 1),
              ),
            ),
          ),
          
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "invtabs");
            },
            leading: Icon(
              Icons.inventory_rounded,
              color: Color.fromRGBO(12, 60, 64, 1),
            ),
            title: Text(
              "Inventario",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 60, 64, 1),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "ventas");
            },
            leading: Icon(
              Icons.monetization_on,
              color: Color.fromRGBO(12, 60, 64, 1),
            ),
            title: Text(
              "Ventas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(12, 60, 64, 1),
              ),
            ),
          )
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

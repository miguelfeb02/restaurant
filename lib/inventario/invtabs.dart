// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:restaurant/inventario/entradas.dart';
import 'package:restaurant/inventario/salidas.dart';
import 'package:restaurant/inventario/stock.dart';
import 'package:restaurant/servicios/widgets.dart';

class Invtabs extends StatefulWidget {
  

  @override
  _InvtabsState createState() => _InvtabsState();
}

class _InvtabsState extends State<Invtabs> {
  final widgetsx = Widgets();
   int selectedIndex = 0;
     List<Widget> tabs = <Widget>[
   Stock(),
   Entradas(),
   Salidas(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widgetsx.drawer(context),
      appBar: AppBar(
         backgroundColor: Color.fromRGBO(12, 60, 64, 1),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_rounded,),
                SizedBox(width:10),
                Text(
                  "Inventario",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            
            elevation: 10,
             actions: [
              Container(
                padding: EdgeInsets.all(10),
                child: IconButton(
                    icon: Icon(Icons.view_column_sharp,color: Colors.white,),
                    onPressed: () {
                     
                    }),
              )
            ],
       ),
      body:Center(
        child: tabs.elementAt(selectedIndex),
      ) ,
      bottomNavigationBar: BottomNavigationBar(
       
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.move_to_inbox),
            label: 'Entradas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outbox),
            label: 'Salidas',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color.fromRGBO(12, 60, 64, 1),
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:restaurant/servicios/widgets.dart';

class Ventas extends StatefulWidget {
  @override
  _VentasState createState() => _VentasState();
}

class _VentasState extends State<Ventas> {

  final widgets = Widgets();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:   widgets.drawer(context),
       appBar: AppBar(
         backgroundColor: Color.fromRGBO(12, 60, 64, 1),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on,),
                SizedBox(width:10),
                Text(
                  "Ventas",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            
            elevation: 10,
             actions: [
              Container(
                padding: EdgeInsets.all(10),
                child: IconButton(
                    icon: Icon(Icons.add,color: Colors.transparent,),
                    onPressed: () {
                     
                    }),
              )
            ],
       ),
       body: Container(),
    );
  }
}

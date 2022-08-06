// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:restaurant/servicios/firebase.dart';
import 'package:restaurant/servicios/widgets.dart';

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  final provider = Providerx();
  final widgets = Widgets();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        descripcion(),
        inventario()],
    ));
  }

  descripcion() {
    final sizes = MediaQuery.of(context).size;
    return Container(
      color: Colors.amber[400],
      width: sizes.width,
      height: sizes.height * 0.07,
      child: Row(
        children: [
          
          SizedBox(width: sizes.width * 0.05, ),
          SizedBox(width: sizes.width * 0.12, child: Text("Codigo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
          SizedBox(width: sizes.width * 0.12, ),
          SizedBox(width: sizes.width * 0.15, child: Text("Nombre",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
          SizedBox(width: sizes.width * 0.15, ),
          SizedBox(width: sizes.width * 0.15, child: Text("Stock",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
           SizedBox(width: sizes.width * 0.07, ),
          SizedBox(width: sizes.width * 0.15, child: Text("Coste",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
        ],
      ),
    );
  }

  inventario() {
    final sizes = MediaQuery.of(context).size;
    return SizedBox(
      height: sizes.height * 0.50,
      child: FutureBuilder(
        future: provider.cargarinsumos(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final datacheck = snapshot.data;

            return ListView.builder(
              itemCount: datacheck!.length,
              itemBuilder: (BuildContext context, int index) {
                return card(datacheck, index);
              },
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueGrey)));
          }
        },
      ),
    );
  }

  card(datacheck, index) {
    final sizes = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
      ),
      child: Row(
        children: [
          SizedBox(width: sizes.width * 0.02, ),
          SizedBox(width: sizes.width * 0.06, child: Text("999",style: TextStyle(fontSize: sizes.width*0.03),)),
          SizedBox(width: sizes.width * 0.03, ),
          SizedBox(
            width: sizes.width * 0.38,
            child: Text(
              datacheck[index].nombre.toUpperCase(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: sizes.width*0.03,
                  color: Color.fromRGBO(12, 60, 64, 1),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: sizes.width * 0.01,
          ),
          SizedBox(
            child: Row(
              children: [
                SizedBox(
                    width: sizes.width * 0.15,
                    child: Text(
                      "${datacheck[index].stock}",style: TextStyle(fontSize: sizes.width*0.03),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(width: sizes.width * 0.07,),
                SizedBox(
                    width: sizes.width * 0.15,
                    child: Text(
                      "${datacheck[index].coste}",style: TextStyle(fontSize: sizes.width*0.03),
                      textAlign: TextAlign.center,
                      
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: avoid_print, unnecessary_null_comparison, unused_local_variable, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:restaurant/controllers/controllerinsumos.dart';

import 'package:restaurant/preferencias/preferencias.dart';
import 'package:restaurant/servicios/cmodel.dart';
import 'package:restaurant/servicios/imodel.dart';

import 'package:restaurant/servicios/pmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Providerx {
  final String url = 'https://restaurant-8c6b0-default-rtdb.firebaseio.com/';
  final pre = PreferenciasUsuario();
  final CurrencyTextInputFormatter formatter =
      CurrencyTextInputFormatter(decimalDigits: 0, locale: "es", symbol: "");

  Future<bool> crearproducto(Pmodel pmodel, List lista, List listavar,
      List nombresvar, List listavarno, List nombresvarno, List precios) async {
    final urlm = '$url/productos.json';
    try {
      final resp = await http.post(Uri.parse(urlm), body: pmodelToJson(pmodel));
      final data = json.decode(resp.body);
      final id = data.toString().substring(7, 27);

      if (pmodel.variantes && pmodel.tipo) {
        for (var i = 0; i < nombresvar.length; i++) {
          final urlm4 = '$url/variantes/$id/${nombresvar[i]}/precioycoste.json';
          await http.post(Uri.parse(urlm4), body: imodelToJson(precios[i]));

          final urlm3 = '$url/variantes/$id/${nombresvar[i]}.json';
          for (var j = 0; j < listavar[i].length; j++) {
            await http.post(Uri.parse(urlm3),
                body: imodelToJson(listavar[i][j]));
          }
        }
      }

      if (pmodel.variantes == false && pmodel.tipo == true) {
        final urlm3 = '$url/variantes/$id.json';
        for (var i = 0; i < lista.length; i++) {
          await http.post(Uri.parse(urlm3), body: imodelToJson(lista[i]));
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarprodcuto(
    Pmodel pmodel,
    List zcomponentes,
    List listavar,
    List nombresvar,
    List listavarno,
    List nombresvarno,
    List precios,
  ) async {
    final urlm = '$url/productos/${pmodel.id}.json';

    await http.put(Uri.parse(urlm), body: pmodelToJson(pmodel));

    if (pmodel.variantes && pmodel.tipo) {
      final urld = '$url/variantes/${pmodel.id}.json';
      await http.delete(Uri.parse(urld));
      for (var i = 0; i < nombresvar.length; i++) {
        final urlm4 =
            '$url/variantes/${pmodel.id}/${nombresvar[i]}/precioycoste.json';
        await http.post(Uri.parse(urlm4), body: imodelToJson(precios[i]));

        for (var j = 0; j < listavar[i].length; j++) {
          final urlm3 = '$url/variantes/${pmodel.id}/${nombresvar[i]}.json';
          await http.post(Uri.parse(urlm3), body: imodelToJson(listavar[i][j]));
        }
      }
    }

    if (pmodel.variantes == false && pmodel.tipo == true) {
      final urld = '$url/variantes/${pmodel.id}.json';
      await http.delete(Uri.parse(urld));
      for (var i = 0; i < zcomponentes.length; i++) {
        final urlx = '$url/variantes/${pmodel.id}.json';
        await http.post(Uri.parse(urlx), body: imodelToJson(zcomponentes[i]));
      }
    }

    return true;
  }

  Future<bool> borrarproducto(id) async {
    try {
      final urlp = '$url/productos/$id.json';
      final urlv = '$url/variantes/$id.json';

      await http.delete(Uri.parse(urlp));
      await http.delete(Uri.parse(urlv));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future cargarproductos() async {
    final urlp = '$url/productos.json';
    try {
      final resp = await http.get(Uri.parse(urlp));

      final data = json.decode(resp.body);
      final List solicitud = [];

      if (data == null) {
        return [];
      }
      data.forEach((id, soli) {
        final solitemp = Pmodel.fromJson(soli);
        solitemp.id = id;
        solicitud.add(solitemp);
      });
      return solicitud;
    } catch (e) {
      print(e);
      return ["error"];
    }
  }

  Future<List> cargarvariantes(pmodel) async {
    final List nombresvariantes = [];
    final List precios = [];
    final List rutasprecios = [];
    final List insumos = [];

    if (pmodel.variantes && pmodel.tipo) {
      final urlp1 = '$url/variantes/${pmodel.id}.json';

      try {
        final resp = await http.get(Uri.parse(urlp1));
        final data = json.decode(resp.body);

        data.forEach((id, soli) {
          nombresvariantes.add(id);
          List<Imodel> grupo = [];

          soli.forEach((id2, soli2) {
            if (id2 != "precioycoste") {
              final temp = Imodel.fromJson(soli2);
              temp.idruta = id2;
              grupo.add(temp);
            }
            if (id2 == "precioycoste") {
              soli2.forEach((id3, soli3) {
                final temp2 = Imodel.fromJson(soli3);
                temp2.idruta = id3;
                precios.add(temp2);
              });
            }
          });
          insumos.add(grupo);
        });

        return [nombresvariantes, precios, insumos];
      } catch (e) {
        return ["error"];
      }
    } else {
      if (pmodel.variantes == false && pmodel.tipo == true) {
        try {
          final urlp3 = '$url/variantes/${pmodel.id}.json';
          final resp = await http.get(Uri.parse(urlp3));
          final data = json.decode(resp.body);
          data.forEach((id, soli) {
            final temp = Imodel.fromJson(soli);
            temp.idruta = id;
            insumos.add(temp);
          });
          return [[], [], insumos];
        } catch (e) {
          return ["error"];
        }
      } else {
        return [];
      }
    }
  }

  Future<bool> crearinsumo(Imodel imodel) async {
    final urlm = '$url/insumos.json';

    await http.post(Uri.parse(urlm), body: imodelToJson(imodel));

    return true;
  }

  Future<bool> editarinsumo(Imodel imodel, id) async {
    try {
      final urlm = '$url/insumos/$id.json';

      await http.put(Uri.parse(urlm), body: imodelToJson(imodel));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> borrarinsumo(id) async {
    try {
      final urlm = '$url/insumos/$id.json';

      await http.delete(Uri.parse(urlm));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> cargarinsumos() async {
    final urlc = '$url/insumos.json';
    try {
      final resp = await http.get(Uri.parse(urlc));
      final data = json.decode(resp.body);
      final List<Imodel> solicitud = [];

      if (data == null) {
        return [];
      }
      data.forEach((id, soli) {
        final solitemp = Imodel.fromJson(soli);
        solitemp.id = id;
        solicitud.add(solitemp);
      });

      return solicitud;
    } catch (e) {
      return ["error"];
    }
  }

  Future<bool> crearcat(Cmodel cmodel) async {
    final urlm = '$url/categorias.json';

    await http.post(Uri.parse(urlm), body: cmodelToJson(cmodel));

    return true;
  }

  Future<bool> editarcat(Cmodel cmodel, idcat, cat, nuevacat) async {
    try {
      final urlc = '$url/categorias/$idcat.json';
      await http.put(Uri.parse(urlc), body: cmodelToJson(cmodel));

      final productos = await cargarproductos();
      for (var i = 0; i < productos.length; i++) {
        if (productos[i].cat == cat) {
          productos[i].cat = nuevacat;
          await editarprocat(productos[i], nuevacat);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarprocat(Pmodel pmodel, cat) async {
    try {
      final urlm = '$url/productos/${pmodel.id}.json';

      await http.put(Uri.parse(urlm), body: pmodelToJson(pmodel));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> borrarcat(id) async {
    try {
      final urlp = '$url/categorias/$id.json';

      await http.delete(Uri.parse(urlp));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> cargarcats() async {
    final urlc = '$url/categorias.json';
    try {
      final resp = await http.get(Uri.parse(urlc));
      final data = json.decode(resp.body);
      final List solicitud = [];

      if (data == null) {
        return [];
      }
      data.forEach((id, soli) {
        final solitemp = Cmodel.fromJson(soli);
        solitemp.id = id;
        solicitud.add(solitemp);
      });

      return solicitud;
    } catch (e) {
      return ["error"];
    }
  }

  Future pass() async {
    try {
      final urlc = '$url/datos.json';
      final resp = await http.get(Uri.parse(urlc));
      final data = json.decode(resp.body);

      return data;
    } catch (e) {
      return {"ref": 0};
    }
  }

  Future refa(dato) async {
    print("yes");
    final urlc = '$url/datos/ref.json';
    await http.put(Uri.parse(urlc), body: "$dato");

    return true;
  }

  Future internet() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } catch (e) {
      return false;
    }

    
  }

  Future<bool> editarcostes(idx, coste) async {
    Controllerinsumos.to.actualtrue();
    final urlp1 = '$url/variantes.json';
    final resp = await http.get(Uri.parse(urlp1));
    final Map<String, dynamic> data = json.decode(resp.body);

    for (var id in data.keys) {
      var soli = data[id];
      for (var id2 in soli.keys) {
        var soli2 = soli[id2];
        if (id2.startsWith("-")) {
          final solitemp = Imodel.fromJson(soli2);
          if (solitemp.id == idx) {
            solitemp.coste = coste;
            solitemp.costefinal = formatter.format(
                (int.parse(solitemp.cantidad) * int.parse(coste)).toString());

            final urlm = '$url/variantes/$id/$id2.json';
            await http.put(Uri.parse(urlm), body: imodelToJson(solitemp));

            final url20 = '$url/variantes/$id.json';
            final resp = await http.get(Uri.parse(url20));
            final data2 = json.decode(resp.body);
            var sum = 0;
            for (var id3 in data2.keys) {
              var soli3 = data2[id3];
              final solitemp3 = Imodel.fromJson(soli3);
              var newValue = solitemp3.costefinal.replaceAll(".", "");
              var e = int.parse(newValue);
              sum += e;
            }

            final url21 = '$url/productos/$id.json';
            final resp2 = await http.get(Uri.parse(url21));
            final data3 = json.decode(resp2.body);
            final solitemp4 = Pmodel.fromJson(data3);
            solitemp4.costetotal = sum.toString();
            await http.put(Uri.parse(url21), body: pmodelToJson(solitemp4));
          }
        } else {
          for (var id4 in soli2.keys) {
            var soli4 = soli2[id4];
            if (id4.startsWith("-")) {
              final solitemp5 = Imodel.fromJson(soli4);
              if (solitemp5.id == idx) {
                solitemp5.coste = coste;
                solitemp5.costefinal = formatter.format(
                    (int.parse(solitemp5.cantidad) * int.parse(coste))
                        .toString());

                final urlm = '$url/variantes/$id/$id2/$id4.json';
                await http.put(Uri.parse(urlm), body: imodelToJson(solitemp5));

                final url22 = '$url/variantes/$id/$id2.json';
                final resp3 = await http.get(Uri.parse(url22));
                final data4 = json.decode(resp3.body);
                var sum = 0;
                for (var id6 in data4.keys) {
                  var soli6 = data4[id6];
                  if (id6.startsWith("-")) {
                    final solitemp6 = Imodel.fromJson(soli6);
                    var newValue = solitemp6.costefinal.replaceAll(".", "");
                    var e = int.parse(newValue);
                    sum += e;
                    final url23 = '$url/variantes/$id/$id2/precioycoste.json';
                    final resp6 = await http.get(Uri.parse(url23));
                    final data6 = json.decode(resp6.body);
                    for (var id7 in data6.keys) {
                      var soli7 = data6[id7];
                      final url23 =
                          '$url/variantes/$id/$id2/precioycoste/$id7.json';
                      final solitemp7 = Imodel.fromJson(soli7);
                      solitemp7.costefinal = sum.toString();
                      await http.put(Uri.parse(url23),
                          body: imodelToJson(solitemp7));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    Controllerinsumos.to.actualfalse();
    return true;
  }
}

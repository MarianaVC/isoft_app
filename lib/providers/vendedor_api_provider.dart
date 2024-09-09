import 'dart:convert';
import 'package:veta/models/vendedor.dart';
import 'package:veta/models/indicadores.dart';
import 'package:veta/providers/db_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:veta/providers/connectivity_provider.dart';

class VendedorApiProvider {
  Future<List<Vendedor>> getAllVendedores() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/vendedor/"); //remove this api url to something nicer
    final response = await http.get(url, headers: {"Content-Type":"application/json "});
    final List body = jsonDecode(utf8.decode(response.bodyBytes));
    final vendedor = body.map((e) => Vendedor.fromJson(e)).toList();
    for (var vend in vendedor) {
      DBProvider.db.createVendedor(vend); // change for bulk create if there's time. 
    }
    return body.map((e) => Vendedor.fromJson(e)).toList();

  }
  // Future<List<Indicador>> getAllIndicadoresFromVendedor(String cveVendedor) async {
  //   var url = Uri.parse("http://10.0.2.2:8000/api/vendedor/$cveVendedor"); //remove this api url to something nicer
  //   print(url);
  //   final response = await http.get(url, headers: {"Content-Type":"application/json "});
  //   final body = json.decode(response.body);
  //   final List indicadores = body['indicadores'];
  //   print(" before $indicadores");
  //   () async {
  //     DBProvider.db.bulkCreateIndicador(indicadores);
  //   }.call();
  //   // insert in db in case there's no internet connection
  //   return indicadores.map((e) => Indicador.fromJson(e)).toList();
  // }

    Future<List<Indicador>> getAllIndicadoresFromVendedor() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/vendedor/indicadores"); //remove this api url to something nicer
    print(url);
    final response = await http.get(url, headers: {"Content-Type":"application/json "});
    final body = json.decode(response.body);
    List indicadores = [];
    for (var vendedor in body){
        if( vendedor['indicadores'].length == 0){
          continue;
        }else{
          // print(vendedor['indicadores']);
          for (var indicador in vendedor['indicadores']){
            print(indicador);
            indicador['cveVendedor'] = vendedor['cveVendedor'];
            indicador = Indicador.fromJson(indicador);
            DBProvider.db.createUpdateIndicador(indicador);
          }
          // print(data);
        }
    }
    // print(" before $indicadores");
    // () async {
    //   DBProvider.db.bulkCreateIndicador(indicadores);
    // }.call();
    // // insert in db in case there's no internet connection
    return indicadores.map((e) => Indicador.fromJson(e)).toList();
  }


  // Future<List<Indicador>> ToggleFutureBuilderIndidacores(String cveVendedor)async{
  // var ConnectivityProvider = CheckConnectionPage();
  // final connection = await ConnectivityProvider.getConnectivityStatus();
  // if (connection == false){
  //   return getAllIndicadoresFromVendedor(cveVendedor!);
  // }else{
  //   return DBProvider.db.getAllIndicadoresFromVendedor(cveVendedor!);
  // }

  // }
}

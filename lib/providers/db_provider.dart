import 'dart:io';
import 'package:veta/models/vendedor.dart';
import 'package:veta/models/indicadores.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider {
  static final DBProvider db = DBProvider._();

  DBProvider._();
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await initDB();
  // Create the database and the Vendedor table
  
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'database_manager_dev4.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Vendedor('
          'id INTEGER AUTO_INCREMENT PRIMARY KEY,'
          'cveVendedor TEXT,'
          'nombre TEXT,'
          'paterno TEXT,'
          'materno TEXT,'
          'razonSocial TEXT,'
          'zona TEXT'
          ')');
        await db.execute('CREATE TABLE Indicador('
          'id INTEGER AUTO_INCREMENT PRIMARY KEY,'
          'cveVendedor TEXT,'
          'facturadoUnidades INTEGER,'
          'facturadoImporte DOUBLE,'
          'devueltoUnidades INTEGER,'
          'devueltoImporte DOUBLE,'
          'ventaNetaUnidades INTEGER,'
          'ventaNetaImporte DOUBLE,'
          'mes INTEGER,'
          'ano INTEGER'
          ')');
    }
    );
  }

  // Insert Indicador on database
  void createUpdateIndicador(Indicador newIndicador) async {
    print("si entré al update");
    final db = await database;
    final cveVendedor = newIndicador.cveVendedor;
    final mes = newIndicador.mes;
    final ano = newIndicador.ano;
    final check = await db.rawQuery("SELECT * FROM Indicador WHERE cveVendedor=? AND mes=? AND ano=?", ["$cveVendedor", "$mes", "$ano"]);
    if (check.isEmpty){
      print(newIndicador.toJson());
        await db.insert('Indicador', newIndicador.toJson());
    }else{
        await db.update('Indicador', newIndicador.toJson(), where: "cveVendedor=? AND mes=? AND ano=?", whereArgs:["$cveVendedor", "$mes", "$ano"]);
    }
  }


  // Insert Vendedor on database
  createVendedor(Vendedor newVendedor) async {
    await deleteAllVendedores();
    final db = await database;
    return await db.insert('Vendedor', newVendedor.toJson());
  }

  void bulkCreateIndicador(indicadores) async {
    for (var indicador in indicadores) {
      db.createUpdateIndicador(indicador);
    }
  }

  // Delete all Vendedores
  Future<int> deleteAllVendedores() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Vendedor');

    return res;
  }

  // Delete all Indicadores
  Future<int> deleteAllIndicadores() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Indicador');

    return res;
  }

  Future<List<Vendedor>> getAllVendedores() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Vendedor");
    List<Vendedor> list =
        res.isNotEmpty ? res.map((c) => Vendedor.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Vendedor>> getCveVendedores() async {
    final db = await database;
    final res = await db.rawQuery("SELECT cveVendedor FROM Vendedor");
    List<Vendedor> list =
        res.isNotEmpty ? res.map((c) => Vendedor.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<Indicador>> getAllIndicadores(cveVendedor,mes1, mes2, ano) async {
    final db = await database;
    String query = "";
    List params = [];
    if (mes1=="" && mes2=="" && ano =="") {
      query = "SELECT * FROM Indicador WHERE cveVendedor=?";
      params = ["$cveVendedor"];
    }else{
      query = "SELECT * FROM Indicador WHERE (cveVendedor=? AND mes=? AND ano=?) OR (cveVendedor=? AND mes=? AND ano=?)";
      var mesUno = getMonths(mes1);
      var mesDos = getMonths(mes2);
      params = ["$cveVendedor", "$mesUno","$ano", "$cveVendedor", "$mesDos", "$ano"];
      // print(params);

    }
    final res = await db.rawQuery(query,params);
    List<Indicador> list =
        res.isNotEmpty ? res.map((c) => Indicador.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<Indicador>> getAllIndicadoresZona(zona, mes1, mes2, ano) async{
        final db = await database;
    String query = "";
    List params = [];
    if (mes1=="" && mes2=="" && ano =="") {
      query = "SELECT * FROM Indicador Inner JOIN Vendedor ON Indicador.cveVendedor = Vendedor.cveVendedor WHERE Vendedor.zona=?";
      params = ["$zona"];
    }else{
      query = "SELECT * FROM Indicador INNER JOIN Vendedor ON Indicador.cveVendedor = Vendedor.cveVendedor WHERE (Vendedor.zona=? AND Indicador.mes=? AND Indicador.ano=?) OR (Vendedor.zona=? AND Indicador.mes=? AND Indicador.ano=?)";
      var mesUno = getMonths(mes1);
      var mesDos = getMonths(mes2);
      params = ["$zona", "$mesUno","$ano", "$zona", "$mesDos", "$ano"];
      // print(params);

    }
    final res = await db.rawQuery(query,params);
    List<Indicador> list =
        res.isNotEmpty ? res.map((c) => Indicador.fromJson(c)).toList() : [];

    return list;
  }
  getMonths(String mes) {
    var int = "";
    // you can adjust this values according to your accuracy requirements
    const Enero = 'Enero'; 
    const Febrero = 'Febrero'; 
    const Marzo = 'Marzo'; 
    const Abril = 'Abril'; 
    const Mayo = 'Mayo'; 
    const Junio = 'Junio';
    const Julio = 'Julio';
    const Agosto = 'Agosto';
    const Septiembre = 'Septiembre';
    const Octubre = 'Octubre'; 
    const Noviembre = 'Noviembre';
    const Diciembre = 'Junio';
    switch (mes) {
    case Enero:
      int = "1";
      break;
    case Febrero: 
      int = "2";
      break;
    case Marzo: 
      int = "3";
      break;
    case Abril: 
      int = "4";
      break;
    case Mayo: 
      int = "5";
      break;
    case Junio: 
      int = "6";
      break;
    case Julio: 
      int = "7";
      break;  
    case Agosto: 
      int = "8";
      break;  
    case Septiembre: 
      int = "9";
      break;
    case Octubre: 
      int = "10";
      break; 
    case Noviembre: 
      int = "11";
      break;  
    case Diciembre: 
      int = "12";
      break;
  }
    return int;
}

  
  Future<List<Indicador>> getAllIndicadoresFromVendedor(String cveVendedor)async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Indicador WHERE cveVendedor=?", ["$cveVendedor"]);
    List<Indicador> list =
        res.isNotEmpty ? res.map((c) => Indicador.fromJson(c)).toList() : [];

    return list;
  }
}
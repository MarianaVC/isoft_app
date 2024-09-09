import 'package:flutter/material.dart';
import 'package:veta/models/vendedor.dart';
import 'package:veta/models/indicadores.dart';
import 'package:veta/pages/graph_indicadores_page.dart';
import 'dart:convert';
import 'package:veta/providers/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:veta/providers/vendedor_api_provider.dart';

const List<String> mes = <String>['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
const List<String> ano = <String>['2024', '2025', '2026', '2027', '2028','2029'];
class DetailScreen extends StatefulWidget {
  // final vendedor = vendedor;
  final Vendedor vendedor;

  DetailScreen({super.key, required this.vendedor});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var apiProvider = VendedorApiProvider();
  late Future<List<Indicador>> FilteredIndicadores;
  String dropdownValue1 = mes.first;
  String dropdownValue2 = mes.first;
  String dropdownValue3 = ano.first;

  @override
    void initState() {
    super.initState();
    FilteredIndicadores = DBProvider.db.getAllIndicadores(widget.vendedor.cveVendedor,"","","");

  }

  @override
  Widget build(BuildContext context) {
    final cveVendedor = widget.vendedor.cveVendedor;
    // Use the Todo to create the UI.
    final nombreCompleto = "${widget.vendedor.nombre!} ${widget.vendedor.paterno!}";



    // Future<List<Indicador>>  get FilteredIndicadores =>  DBProvider.db.getAllIndicadores(dropdownValue1,dropdownValue2,dropdownValue3);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Indicadores de $nombreCompleto") ,

      ),
      body: Column(
        children: [
      IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> GraphIndicadoresPage(vendedor:widget.vendedor)));
        }, 
        icon: Icon(Icons.graphic_eq),
        ),      
      DropdownButton<String>(
      value: dropdownValue1,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        
        // This is called when the user selects an item.
        setState(() {
          dropdownValue1 = value!;

        });
      },
      items: mes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()),
      DropdownButton<String>(
      value: dropdownValue2,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue2 = value!;
        });
      },
      items: mes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()) ,         
      DropdownButton<String>(
      value: dropdownValue3,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue3 = value!;  
          FilteredIndicadores = DBProvider.db.getAllIndicadores(cveVendedor,dropdownValue1,dropdownValue2,dropdownValue3);
    
        });
      },
      items: ano.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()) ,  
          Expanded(
          // padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Indicador>>(
          future: FilteredIndicadores,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              //show loader
              return const CircularProgressIndicator();
            } else if(snapshot.hasData){
              //display data on screen
             final indicadores = snapshot.data!;
             return buildIndicadores(indicadores);
            } else{
              // if no data, show text:
              return const Text("No hay datos disponibles");
              
            }
          }
        )
      ),]

    )
    
    );
  }
  // function to display fetched data on screen
Widget buildIndicadores(List<Indicador> indicadores){
  return ListView.builder(scrollDirection: Axis.vertical,shrinkWrap: true,itemCount: indicadores.length, itemBuilder: (context, index) {
  final indicador = indicadores[index];
  final facturadoUnidades = indicador.facturadoUnidades.toString();
  final facturadoImporte = indicador.facturadoImporte.toString();
  final devueltoUnidades = indicador.devueltoUnidades.toString();
  final devueltoImporte = indicador.devueltoImporte.toString();
  final ventaNetaUnidades = indicador.ventaNetaUnidades.toString();
  final ventaNetaImporte = indicador.ventaNetaImporte.toString();
  final mes = indicador.mes.toString();
  final ano = indicador.ano.toString();
  return Container(
    color: Colors.grey.shade200,
    padding: const EdgeInsets.symmetric(vertical:15, horizontal:15),
    child: DataTable(
    border: TableBorder.all(),  
    columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Indicador',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Unidad/Importe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )],
    rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Facturado en unidades', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(facturadoUnidades)),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Facturado en importe', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(facturadoImporte)),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Devuelto en unidades', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(devueltoUnidades)),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Devuelto en importe', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(devueltoImporte)),
            ],
          ),
          DataRow(
          cells: <DataCell>[
              const DataCell(Text('Venta neta en unidades', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(ventaNetaUnidades)),
            ],
          ),
          DataRow(
          cells: <DataCell>[
              const DataCell(Text('Venta neta en importe', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(ventaNetaImporte)),
            ],
          ),
          DataRow(
          cells: <DataCell>[
              const DataCell(Text('Mes', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(mes)),
            ],
          ),
          DataRow(
          cells: <DataCell>[
              const DataCell(Text('Año', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(ano)),
            ],
          ),
        ],
    ),
  );


});
}
}
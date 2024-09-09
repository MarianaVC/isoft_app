import 'package:flutter/material.dart';
import 'package:veta/models/indicadores.dart';
import 'package:veta/providers/db_provider.dart';
import 'package:veta/pages/graph_zona_indicadores_screen.dart';

const List<String> mes = <String>['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
const List<String> ano = <String>['2024', '2025', '2026', '2027', '2028','2029'];

class IndicadoresZonasPage extends StatefulWidget {
  final String zona;
  const IndicadoresZonasPage({super.key, required this.zona});
  @override
  State<IndicadoresZonasPage> createState() => _IndicadoresZonasPageState();

}

class _IndicadoresZonasPageState extends State<IndicadoresZonasPage> {
  late Future<List<Indicador>> FilteredIndicadores;


  @override
    void initState() {
    super.initState();
    FilteredIndicadores = DBProvider.db.getAllIndicadoresZona(widget.zona,"","","");

  }
  String dropdownValue1 = mes.first;
  String dropdownValue2 = mes.first;
  String dropdownValue3 = ano.first;  
  @override
  Widget build(BuildContext context) {
    final zona = widget.zona;    
    return Scaffold(
      appBar: AppBar(
        title: Text("Indicadores de zona $zona") ,
      ),
      body: Column(
        children: [
      IconButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> GraphZonaIndicadoresPage(zona:widget.zona)));
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
          FilteredIndicadores = DBProvider.db.getAllIndicadoresZona(widget.zona,dropdownValue1,dropdownValue2,dropdownValue3);
    
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
             return buildIndicadoresZona(indicadores);
            } else{
              // if no data, show text:
              return const Text("No hay datos disponibles");
              
            }
          }
        )
      ),]

    )
    )
    ;
  }
    // function to display fetched data on screen
Widget buildIndicadoresZona(List<Indicador> indicadores){
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
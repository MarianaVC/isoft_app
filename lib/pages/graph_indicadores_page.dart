import 'package:flutter/material.dart';
import 'package:veta/models/vendedor.dart';
import 'package:veta/models/indicadores.dart';
import 'package:veta/providers/vendedor_api_provider.dart';
import 'package:veta/providers/db_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const List<String> mes = <String>['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
const List<String> ano = <String>['2024', '2025', '2026', '2027', '2028','2029'];

class GraphIndicadoresPage extends StatefulWidget {
  final Vendedor vendedor;
  const GraphIndicadoresPage({super.key, required this.vendedor});
  @override
  State<GraphIndicadoresPage> createState() => _GraphIndicadoresPageState();

}
  class ChartData {
        ChartData(this.x, this.y);
        final int x;
        final double y;
    }

class _GraphIndicadoresPageState extends State<GraphIndicadoresPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Gráficas de indicadores de $nombreCompleto") ,

      ),
      body: Column(
        children: [
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
  
Widget buildIndicadores(List<Indicador> indicadores){
var ventaNetaImporte = 0.0;
var facturadoImporte = 0.0;
var devueltoImporte = 0.0;
var facturadoUnidades = 0;
var devueltoUnidades = 0;
var VentaNetaUnidades = 0;


  for (var indicador in indicadores){
    ventaNetaImporte += indicador.ventaNetaImporte!;
      ventaNetaImporte += indicador.ventaNetaImporte!;
      facturadoImporte += indicador.facturadoImporte!;
      devueltoImporte += indicador.devueltoImporte!;
      facturadoUnidades += indicador.facturadoUnidades!;
      devueltoUnidades += indicador.devueltoUnidades!;
      VentaNetaUnidades += indicador.ventaNetaUnidades!;

  }
          final List<ChartData> chartData1 = [
            ChartData(1, ventaNetaImporte),
            ChartData(2, facturadoImporte),
            ChartData(3, devueltoImporte),
        ];
        final List<ChartData> chartData2 = [
            ChartData(1, VentaNetaUnidades.toDouble()),
            ChartData(2, facturadoUnidades.toDouble()),
            ChartData(3, devueltoUnidades.toDouble()),
        ];
          return SingleChildScrollView(
            child: Center(
                child: Column(
                    children: [SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                            title: AxisTitle(
                                text: 'Venta Neta Facturado en importe Devuelto en importe',
                                textStyle: TextStyle(
                                    color: Colors.deepOrange,
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300
                                )
                            )
                        ),
                        series: <CartesianSeries<ChartData, int>>[
                            // Renders column chart
                            ColumnSeries<ChartData, int>(
                                dataSource: chartData1,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ]
                    ),
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                            title: AxisTitle(
                                text: 'Venta Unidades Facturado en unidades Devuelto unidades',
                                textStyle: TextStyle(
                                    color: Colors.deepOrange,
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300
                                )
                            )
                        ),
                        series: <CartesianSeries<ChartData, int>>[
                            // Renders column chart
                            ColumnSeries<ChartData, int>(
                                dataSource: chartData2,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ]
                )]
                    )
            )
                   
            );


}

}
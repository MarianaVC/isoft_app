import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:veta/pages/indicadores_zonas_screen.dart';
const List<String> zonas = <String>['Este', 'Noreste', 'Centro-norte', 'Suroeste', 'Noroeste','Suroeste', 'Oeste', 'Centro-sur'];

class ZonasPage extends StatefulWidget {
  const ZonasPage({super.key});
  @override
  State<ZonasPage> createState() => _ZonasPageState();
}

class _ZonasPageState extends State<ZonasPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zonas Geográficas'),
        centerTitle: false,
        ),
        body: ListView.builder(
          itemCount: zonas.length,
          itemBuilder: (context, index){
            final zona = zonas[index];
            return ListTile(
              title: Text("$zona"),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=> IndicadoresZonasPage(zona:zonas[index])));},
            );
            

          }
        )

    );
  }

}



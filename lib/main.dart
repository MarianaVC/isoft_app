import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:veta/models/vendedor.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Veta Company',  
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/home': (context) => const MyHomePage(),
        },
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Vendedor>> vendedoresFuture = getVendedor();
  int _currentIndex = 0;
  // final List<Widget> _screens = [
  //   const HomeScreen(),
  //   const SavedScreen(),
  //   const FavoritesScreen()
  // ];

  static Future<List<Vendedor>> getVendedor() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/vendedor/"); //remove this api url to something nicer
    final response = await http.get(url, headers: {"Content-Type":"application/json "});
    final List body1 = json.decode(response.body);
    final List body = jsonDecode(utf8.decode(response.bodyBytes));
    print(body);
    // final body_aca = body1.runtimeType;
    // print("body1 type $body_aca");

    // print("Este $body");
    try {
      print("Aca");
      print(body.map((e) => Vendedor.fromJson(e)).toList());
    } catch (e) {
      print(" Error! $e");
    }
    return body.map((e) => Vendedor.fromJson(e)).toList();

}

  // final List<Widget> _screens = [
  //   const MyHomePage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Veta Company'),
      ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.logout_rounded), label: 'Salir'),
        ],
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: Center(
        //FutureBuilder
        child: FutureBuilder<List<Vendedor>>(
          future: vendedoresFuture,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting){
              // print(snapshot.hasData);
              //show loader
              return const CircularProgressIndicator();
            } else if(snapshot.hasData){
              //display data on screen
             final vendedores = snapshot.data!;
             return buildVendedores(vendedores);
            } else{
              // if no data, show text:
              return const Text("No hay datos disponibles");
              
            }
          }
        )
      ),
    );
  }
}

// function to display fetched data on screen
Widget buildVendedores(List<Vendedor> vendedores){
  //ListBuilder to show data in a list
  return ListView.builder(itemCount: vendedores.length, itemBuilder: (context, index) {
    final vendedor = vendedores[index];
    return Container(
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical:5, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical:5, horizontal: 5),
      height:100,
      width: double.maxFinite,
      child: Row(
        children: [
        Expanded(flex:1, child: Text(vendedor.nombre!)),
        Expanded(flex:1, child:Text(vendedor.paterno!)),
        Expanded(flex:1, child:Text(vendedor.materno!)),
        Expanded(flex:2, child:Text(vendedor.razonSocial!)),
      ],
    ),
  );
  },
  );
}

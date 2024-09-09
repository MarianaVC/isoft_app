import 'dart:convert';

class Vendedor {
    String? cveVendedor;
    String? nombre;
    String? paterno;
    String? materno;
    String? razonSocial;

    Vendedor({this.cveVendedor, this.nombre, this.paterno, this.materno, this.razonSocial});
    
    Vendedor.fromJson(Map<String, dynamic> json){
      cveVendedor = json['cve_vendedor'];
      nombre = json['nombre'];
      paterno = json['paterno'];
      materno = json['materno'];
      razonSocial = json['razon_social'];
    }
}

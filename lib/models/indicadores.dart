class Indicador {
    String? cveVendedor;
    int? facturadoUnidades;
    double? facturadoImporte;
    int? devueltoUnidades;
    double? devueltoImporte;
    int? ventaNetaUnidades;
    double? ventaNetaImporte;
    int? mes;
    int? ano;

    Indicador({
      this.cveVendedor,
      this.facturadoUnidades,
      this.facturadoImporte,
      this.devueltoUnidades,
      this.devueltoImporte,
      this.ventaNetaUnidades,
      this.ventaNetaImporte,
      this.mes,
      this.ano
    });
    
    Indicador.fromJson(Map<String, dynamic> json){
      cveVendedor = json['cveVendedor'];
      facturadoUnidades = json['facturadoUnidades'];
      facturadoImporte = json['facturadoImporte'].toDouble();
      devueltoUnidades = json['devueltoUnidades'];
      devueltoImporte = json['devueltoImporte'].toDouble();
      ventaNetaUnidades = json['ventaNetaUnidades'];
      ventaNetaImporte = json['ventaNetaImporte'].toDouble();
      mes = json['mes'];
      ano = json['ano'];
    }
  Map<String, dynamic> toJson() => {
        "cveVendedor": cveVendedor,
        "facturadoUnidades": facturadoUnidades,
        "facturadoImporte": facturadoImporte,
        "devueltoUnidades": devueltoUnidades,
        "devueltoImporte": devueltoImporte,
        "ventaNetaUnidades": ventaNetaUnidades,
        "ventaNetaImporte": ventaNetaImporte,
        "mes": mes,
        "ano":ano,
      };    
}
import 'package:flutter/material.dart';

void main() => runApp(MarketplaceApp());

class MarketplaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace PRO',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marketplace PRO")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.store, color: Colors.green),
              title: Text("Cliente - Vitrine"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPadrao("Vitrine de Produtos"))),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.blue),
              title: Text("Vendedor - Painel"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPadrao("Painel do Vendedor"))),
            ),
            ListTile(
              leading: Icon(Icons.delivery_dining, color: Colors.orange),
              title: Text("Entregador - Entregas"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPadrao("Painel de Entregas"))),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaPadrao extends StatelessWidget {
  final String titulo;
  TelaPadrao(this.titulo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(child: Text("Você está na tela: $titulo", style: TextStyle(fontSize: 20))),
    );
  }
}

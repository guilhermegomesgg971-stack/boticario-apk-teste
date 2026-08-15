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
      appBar: AppBar(title: Text("Marketplace PRO - Pres. Dutra")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.store),
              title: Text("Cliente"),
              onTap: () => print("Abrir Vitrine"),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Vendedor"),
              onTap: () => print("Abrir Painel Loja"),
            ),
            ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text("Entregador"),
              onTap: () => print("Abrir Entregas"),
            ),
          ],
        ),
      ),
    );
  }
}

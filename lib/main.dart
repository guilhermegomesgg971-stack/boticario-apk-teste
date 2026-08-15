import 'package:flutter/material.dart';

void main() {
  runApp(const BoticarioApp());
}

class BoticarioApp extends StatelessWidget {
  const BoticarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boticário - Controle de Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const TelaSelecaoPerfil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaSelecaoPerfil extends StatelessWidget {
  const TelaSelecaoPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O.BOTICÁRIO - Acesso ao Sistema'),
        backgroundColor: Colors.purple[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Colors.purple),
            const SizedBox(height: 20),
            const Text(
              'Selecione o seu Perfil de Acesso:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text('Cliente / Vitrine', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeCliente()));
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.store, color: Colors.white),
              label: const Text('Vendedor / Loja', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeVendedor()));
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[900],
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.delivery_dining, color: Colors.white),
              label: const Text('Entregador', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeEntregador()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCliente extends StatelessWidget {
  const HomeCliente({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vitrine - Cliente'), backgroundColor: Colors.purple),
      body: const Center(child: Text('Painel do Cliente (Catálogo e Pedidos)')),
    );
  }
}

class HomeVendedor extends StatelessWidget {
  const HomeVendedor({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel - Vendedor'), backgroundColor: Colors.purple[700]),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Gerenciamento de Ocorrências e Termo'),
      ),
    );
  }
}

class HomeEntregador extends StatelessWidget {
  const HomeEntregador({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel - Entregador'), backgroundColor: Colors.purple[900]),
      body: const Center(child: Text('Painel de Coletas e Conferência')),
    );
  }
}

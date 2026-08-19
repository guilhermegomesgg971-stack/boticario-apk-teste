import 'package:flutter/material.dart';

void main() => runApp(MarketplaceApp());

// ================= ESTADO GLOBAL DO SISTEMA =================
List<Map<String, dynamic>> pedidosGlobais = [];
List<Map<String, dynamic>> entregasProntasGlobais = [];
List<Map<String, dynamic>> pedidosEmAndamentoCliente = [];

class MarketplaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace PRO - Pres. Dutra',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marketplace PRO - Central Avançada")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selecione o painel para testar os fluxos avançados:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            _buildMenuCard(context, "Área do Cliente", "Vitrine, Rastreamento ao Vivo e Carrinho", Icons.store, Colors.green, ClienteScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Vendedor", "Gestão de Vitrine, Status e Despacho", Icons.shopping_bag, Colors.blue, VendedorScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Entregador", "Mapa GPS Integrado e Extrato de Corridas", Icons.delivery_dining, Colors.orange, EntregadorScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      ),
    );
  }
}

// ================= TELA DO CLIENTE =================
class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final List<Map<String, dynamic>> produtos = [
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "loja": "Açaí do Centro", "categoria": "Sobremesas"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "loja": "Pizzaria Bella", "categoria": "Alimentação"},
    {"nome": "Hambúrguer Artesanal Completo", "preco": 28.50, "loja": "Burger House", "categoria": "Alimentação"},
  ];

  final List<Map<String, dynamic>> carrinho = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vitrine do Cliente"),
        actions: [
          IconButton(
            icon: Icon(Icons.radar, color: Colors.white),
            tooltip: "Rastrear Pedidos",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RastreioClienteScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(p["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${p["loja"]} - R\$ ${p["preco"].toStringAsFixed(2)}"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() => carrinho.add(p));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${p["nome"]} adicionado!")));
                },
                child: Text("Comprar", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Carrinho: ${carrinho.length} itens", style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: carrinho.isEmpty ? null : () {
                setState(() {
                  final novoPedido = {
                    "id": "Pedido #${DateTime.now().second}",
                    "itens": carrinho.map((i) => i["nome"]).join(", "),
                    "total": carrinho.fold(0.0, (s, i) => s + i["preco"]),
                    "etapa": 1 // 1: Aguardando Vendedor
                  };
                  pedidosGlobais.add(novoPedido);
                  pedidosEmAndamentoCliente.add(novoPedido);
                  carrinho.clear();
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => RastreioClienteScreen()));
              },
              child: Text("Finalizar Pedido e Rastrear", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DE RASTREIO AO VIVO DO CLIENTE (COM LINHA DO TEMPO)
class RastreioClienteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rastreamento em Tempo Real")),
      body: pedidosEmAndamentoCliente.isEmpty
          ? Center(child: Text("Nenhum pedido ativo no momento."))
          : ListView.builder(
              itemCount: pedidosEmAndamentoCliente.length,
              itemBuilder: (context, index) {
                final p = pedidosEmAndamentoCliente[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p["id"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Itens: ${p["itens"]}"),
                        SizedBox(height: 15),
                        LinearProgressIndicator(value: 0.6, color: Colors.green),
                        SizedBox(height: 15),
                        _buildPassoRastreio("1. Pedido enviado à loja", true),
                        _buildPassoRastreio("2. Loja preparando o pedido", true),
                        _buildPassoRastreio("3. Entregador a caminho da entrega", false),
                        _buildPassoRastreio("4. Pedido entregue", false),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPassoRastreio(String texto, bool concluido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(concluido ? Icons.check_circle : Icons.radio_button_unchecked, color: concluido ? Colors.green : Colors.grey),
          SizedBox(width: 10),
          Text(texto, style: TextStyle(color: concluido ? Colors.black : Colors.grey, fontWeight: concluido ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// ================= TELA DO VENDEDOR =================
class VendedorScreen extends StatefulWidget {
  @override
  _VendedorScreenState createState() => _VendedorScreenState();
}

class _VendedorScreenState extends State<VendedorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor (${pedidosGlobais.length} novos)")),
      body: pedidosGlobais.isEmpty
          ? Center(child: Text("Nenhum pedido recebido ainda."))
          : ListView.builder(
              itemCount: pedidosGlobais.length,
              itemBuilder: (context, index) {
                final p = pedidosGlobais[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(p["id"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Itens: ${p["itens"]}\nTotal: R\$ ${p["total"].toStringAsFixed(2)}"),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        setState(() {
                          entregasProntasGlobais.add({
                            "pedido": p["id"],
                            "rota": "Loja Central ➔ Endereço do Cliente",
                            "taxa": "R\$ 12,00"
                          });
                          pedidosGlobais.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pedido despachado para o entregador!")));
                      },
                      child: Text("Despachar", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ================= TELA DO ENTREGADOR (COM SIMULAÇÃO DE MAPA GPS) =================
class EntregadorScreen extends StatefulWidget {
  @override
  _EntregadorScreenState createState() => _EntregadorScreenState();
}

class _EntregadorScreenState extends State<EntregadorScreen> {
  double ganhosTotais = 120.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Entregador - Ganhos: R\$ ${ganhosTotais.toStringAsFixed(2)}")),
      body: entregasProntasGlobais.isEmpty
          ? Center(child: Text("Nenhuma rota disponível no momento."))
          : ListView.builder(
              itemCount: entregasProntasGlobais.length,
              itemBuilder: (context, index) {
                final e = entregasProntasGlobais[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        color: Colors.blue[50],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 40, color: Colors.blue),
                              Text("Simulação de Mapa GPS Ativa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                              Text("Rota: ${e["rota"]}", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(e["pedido"], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Taxa da Corrida: ${e["taxa"]}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () {
                            setState(() {
                              ganhosTotais += 12.00;
                              entregasProntasGlobais.removeAt(index);
                            });
                            showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: Text("Corrida Concluída!"),
                                content: Text("Você completou a entrega com sucesso. R\$ 12,00 adicionados aos seus ganhos."),
                                actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text("OK"))],
                              ),
                            );
                          },
                          child: Text("Aceitar e Concluir", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

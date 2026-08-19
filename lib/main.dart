import 'package:flutter/material.dart';

void main() => runApp(MarketplaceApp());

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
      appBar: AppBar(title: Text("Marketplace PRO - Pres. Dutra")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selecione o setor:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            _buildMenuCard(context, "Área do Cliente", "Vitrine, carrinho, cupons, chat e atalhos", Icons.store, Colors.green, ClienteScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Vendedor", "Estoque, relatórios, status, tempo e pedidos", Icons.shopping_bag, Colors.blue, VendedorScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Entregador", "Rotas GPS, ganhos, suporte, reputação e corridas", Icons.delivery_dining, Colors.orange, EntregadorScreen()),
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

// ================= TELA DO CLIENTE (TODOS OS BOTÕES) =================
class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final List<Map<String, dynamic>> produtos = [
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "loja": "Açaí do Centro", "categoria": "Sobremesas"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "loja": "Pizzaria Bella", "categoria": "Alimentação"},
    {"nome": "Hambúrguer Artesanal Completo", "preco": 28.50, "loja": "Burger House", "categoria": "Alimentação"},
    {"nome": "Água Mineral 20L", "preco": 12.00, "loja": "Disque Água", "categoria": "Mercado"},
  ];

  final List<Map<String, dynamic>> carrinho = [];
  String categoriaFiltro = "Todos";

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = categoriaFiltro == "Todos" 
        ? produtos 
        : produtos.where((p) => p["categoria"] == categoriaFiltro).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Painel do Cliente"),
        actions: [
          IconButton(
            icon: Icon(Icons.wallet),
            tooltip: "Carteira / Cashback",
            onPressed: () {}, // TODO: Programar botão da carteira
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7 BOTÕES DE ATALHO DO CLIENTE
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _at(Icons.motorcycle, "Acompanhar", Colors.orange, () {}),
                    _at(Icons.star, "Avaliar", Colors.amber, () {}),
                    _at(Icons.favorite, "Favoritos", Colors.red, () {}),
                    _at(Icons.local_offer, "Cupons", Colors.green, () {}),
                    _at(Icons.location_on, "Endereço", Colors.blue, () {}),
                    _at(Icons.history, "Pedir de Novo", Colors.purple, () {}),
                    _at(Icons.chat, "Chat Loja", Colors.teal, () {}),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // FILTROS DE CATEGORIA
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ["Todos", "Alimentação", "Sobremesas", "Mercado"].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: categoriaFiltro == cat,
                      onSelected: (bool selected) => setState(() => categoriaFiltro = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Vitrine Disponível", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final p = produtosFiltrados[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(p["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${p["loja"]} • R\$ ${p["preco"].toStringAsFixed(2)}"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        setState(() => carrinho.add(p));
                      },
                      child: Text("Comprar", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Carrinho: ${carrinho.length} itens", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text("Finalizar Pedido", style: TextStyle(color: Colors.white)),
              onPressed: () {}, // TODO: Programar finalizar pedido
            ),
          ],
        ),
      ),
    );
  }

  Widget _at(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 20)),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ================= TELA DO VENDEDOR (TODOS OS CARDS) =================
class VendedorScreen extends StatefulWidget {
  @override
  _VendedorScreenState createState() => _VendedorScreenState();
}

class _VendedorScreenState extends State<VendedorScreen> {
  bool lojaAberta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: lojaAberta ? Colors.green[50] : Colors.red[50],
              child: SwitchListTile(
                title: Text(lojaAberta ? "Status: Loja Aberta" : "Status: Loja Fechada", style: TextStyle(fontWeight: FontWeight.bold)),
                value: lojaAberta,
                onChanged: (v) => setState(() => lojaAberta = v),
              ),
            ),
            SizedBox(height: 8),

            // CARDS DE GESTÃO DO VENDEDOR
            _cardAcao(Icons.assessment, "Histórico de Vendas", "R\$ 320,00 faturados hoje", Colors.purple, () {}),
            _cardAcao(Icons.star, "Reputação da Loja", "Nota 4.9 (42 avaliações)", Colors.amber, () {}),
            _cardAcao(Icons.timer, "Tempo de Preparo", "Atual: 30-40 min", Colors.orange, () {}),
            _cardAcao(Icons.local_offer, "Gerenciar Cupons", "Status: Desativado", Colors.redAccent, () {}),
            _cardAcao(Icons.chat, "Suporte e Relatórios via WhatsApp", "Fale com a administração", Colors.teal, () {}),

            Divider(height: 30),
            Text("Pedidos Recebidos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text("Pedido #1 - R\$ 45,00", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Itens: Pizza Marguerita Grande"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {}, // TODO: Programar despacho
                  child: Text("Pronto p/ Entrega", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAcao(IconData icon, String titulo, String sub, Color cor, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: cor),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ================= TELA DO ENTREGADOR (TODOS OS CARDS) =================
class EntregadorScreen extends StatefulWidget {
  @override
  _EntregadorScreenState createState() => _EntregadorScreenState();
}

class _EntregadorScreenState extends State<EntregadorScreen> {
  bool online = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Entregador")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: online ? Colors.orange[50] : Colors.grey[200],
              child: SwitchListTile(
                title: Text(online ? "Status: Online" : "Status: Offline", style: TextStyle(fontWeight: FontWeight.bold)),
                value: online,
                onChanged: (v) => setState(() => online = v),
              ),
            ),
            SizedBox(height: 8),

            // CARDS DO ENTREGADOR
            Card(
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.green),
                title: Text("Extrato de Ganhos", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Faturado hoje: R\$ 95,00"),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text("Reputação na Praça", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Nota: 4.9 ⭐ (Excelente)"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.support_agent, color: Colors.blueAccent),
                title: Text("Suporte para Entregadores", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Ajuda com endereço ou cliente ausente"),
                onTap: () {},
              ),
            ),

            Divider(height: 30),
            Text("Entregas Prontas nas Lojas:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.motorcycle, color: Colors.orange, size: 30),
                title: Text("Pedido #1", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Rota: Estabelecimento ➔ Cliente • Taxa: R\$ 12,00"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {}, // TODO: Programar aceitar corrida
                  child: Text("Aceitar", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

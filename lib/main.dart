import 'package:flutter/material.dart';

void main() => runApp(MarketplaceApp());

// ================= DADOS GLOBAIS DE INTEGRAÇÃO =================
List<Map<String, dynamic>> pedidosGlobais = [];
List<Map<String, dynamic>> entregasProntasGlobais = [];

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
              "Selecione o setor para testar as interações em massa:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            _buildMenuCard(context, "Área do Cliente", "Vitrine, carrinho, cupons e chat", Icons.store, Colors.green, ClienteScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Vendedor", "Estoque, relatórios, status e pedidos", Icons.shopping_bag, Colors.blue, VendedorScreen()),
            SizedBox(height: 15),
            _buildMenuCard(context, "Área do Entregador", "Rotas GPS, ganhos, status e corridas", Icons.delivery_dining, Colors.orange, EntregadorScreen()),
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

// ================= TELA DO CLIENTE (TODOS OS BOTÕES INTERATIVOS) =================
class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final List<Map<String, dynamic>> produtos = [
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "loja": "Açaí do Centro", "estoque": 10, "categoria": "Sobremesas"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "loja": "Pizzaria Bella", "estoque": 5, "categoria": "Alimentação"},
    {"nome": "Hambúrguer Artesanal Completo", "preco": 28.50, "loja": "Burger House", "estoque": 12, "categoria": "Alimentação"},
    {"nome": "Água Mineral 20L", "preco": 12.00, "loja": "Disque Água", "estoque": 20, "categoria": "Mercado"},
  ];

  final List<Map<String, dynamic>> carrinho = [];
  String categoriaFiltro = "Todos";
  String statusPedidoAtual = "Nenhum pedido em andamento";
  double saldoCashback = 25.00;

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
            tooltip: "Cashback",
            onPressed: () => _mostrarAlerta("Carteira Digital", "Seu saldo de Cashback é de R\$ ${saldoCashback.toStringAsFixed(2)}."),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE ATALHOS SUPERIOR (TODOS OS 7 BOTÕES)
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _at(Icons.motorcycle, "Acompanhar", Colors.orange, () => _mostrarAlerta("Status", statusPedidoAtual)),
                    _at(Icons.star, "Avaliar", Colors.amber, () => _mostrarAlerta("Avaliação", "Último pedido avaliado com sucesso! ⭐⭐⭐⭐⭐")),
                    _at(Icons.favorite, "Favoritos", Colors.red, () => _mostrarSnack("Abrindo lista de lojas favoritas...")),
                    _at(Icons.local_offer, "Cupons", Colors.green, () => _mostrarAlerta("Cupons", "Disponíveis:\n• PRIMEIRACOMPRA (R\$ 10 OFF)\n• FRETEGRATIS")),
                    _at(Icons.location_on, "Endereço", Colors.blue, () => _mostrarAlerta("Endereço", "Rua Principal, 120 - Centro, Pres. Dutra")),
                    _at(Icons.history, "Pedir de Novo", Colors.purple, () => _mostrarSnack("Repetindo último pedido de Açaí...")),
                    _at(Icons.chat, "Chat Loja", Colors.teal, () => _mostrarSnack("Abrindo chat com o estabelecimento...")),
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
                        _mostrarSnack("${p["nome"]} adicionado!");
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
              onPressed: carrinho.isEmpty ? null : () {
                setState(() {
                  statusPedidoAtual = "Enviado para a Loja";
                  pedidosGlobais.add({
                    "id": "Pedido #${DateTime.now().second}",
                    "itens": carrinho.map((i) => i["nome"]).join(", "),
                    "total": carrinho.fold(0.0, (s, i) => s + i["preco"]),
                    "status": "Aguardando Preparo"
                  });
                  carrinho.clear();
                });
                _mostrarAlerta("Sucesso", "Pedido enviado ao Vendedor!");
              },
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

  void _mostrarAlerta(String titulo, String msg) {
    showDialog(context: context, builder: (c) => AlertDialog(title: Text(titulo), content: Text(msg), actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text("OK"))]));
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: Duration(milliseconds: 800)));
  }
}

// ================= TELA DO VENDEDOR (TODOS OS BOTÕES INTERATIVOS) =================
class VendedorScreen extends StatefulWidget {
  @override
  _VendedorScreenState createState() => _VendedorScreenState();
}

class _VendedorScreenState extends State<VendedorScreen> {
  bool lojaAberta = true;
  String tempoPreparo = "30-40 min";
  String cupomStatus = "Desativado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor (${pedidosGlobais.length} novos)")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS LOJA
            Card(
              color: lojaAberta ? Colors.green[50] : Colors.red[50],
              child: SwitchListTile(
                title: Text(lojaAberta ? "Loja Aberta" : "Loja Fechada", style: TextStyle(fontWeight: FontWeight.bold)),
                value: lojaAberta,
                onChanged: (v) => setState(() => lojaAberta = v),
              ),
            ),
            SizedBox(height: 8),

            // CARDS DE GESTÃO (HISTÓRICO, AVALIAÇÕES, TEMPO, CUPOM)
            _cardAcao(Icons.assessment, "Histórico de Vendas", "R\$ 320,00 faturados hoje", Colors.purple, () {
              _alerta("Relatório", "Total de vendas: R\$ 320,00\nPedidos concluídos: 10");
            }),
            _cardAcao(Icons.star, "Reputação da Loja", "Nota 4.9 (42 avaliações)", Colors.amber, () {
              _alerta("Avaliações", "• Ótimo atendimento!\n• Comida excelente.");
            }),
            _cardAcao(Icons.timer, "Tempo de Preparo", "Atual: $tempoPreparo", Colors.orange, () {
              setState(() => tempoPreparo = tempoPreparo == "30-40 min" ? "45-60 min" : "30-40 min");
              _snack("Tempo alterado para $tempoPreparo");
            }),
            _cardAcao(Icons.local_offer, "Gerenciar Cupons", "Status: $cupomStatus", Colors.redAccent, () {
              setState(() => cupomStatus = cupomStatus == "Desativado" ? "Ativo (10% OFF)" : "Desativado");
            }),

            Divider(height: 30),
            Text("Pedidos Recebidos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            pedidosGlobais.isEmpty
                ? Padding(padding: EdgeInsets.all(20), child: Center(child: Text("Nenhum pedido pendente.")))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pedidosGlobais.length,
                    itemBuilder: (context, index) {
                      final p = pedidosGlobais[index];
                      return Card(
                        child: ListTile(
                          title: Text("${p["id"]} - R\$ ${p["total"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Itens: ${p["itens"]}"),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            onPressed: () {
                              setState(() {
                                entregasProntasGlobais.add({
                                  "pedido": p["id"],
                                  "rota": "Estabelecimento ➔ Cliente",
                                  "valor": "R\$ 12,00"
                                });
                                pedidosGlobais.removeAt(index);
                              });
                              _snack("Despachado para os entregadores!");
                            },
                            child: Text("Pronto p/ Entrega", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
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

  void _alerta(String t, String m) => showDialog(context: context, builder: (c) => AlertDialog(title: Text(t), content: Text(m), actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text("OK"))]));
  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
}

// ================= TELA DO ENTREGADOR (TODOS OS BOTÕES INTERATIVOS) =================
class EntregadorScreen extends StatefulWidget {
  @override
  _EntregadorScreenState createState() => _EntregadorScreenState();
}

class _EntregadorScreenState extends State<EntregadorScreen> {
  bool online = true;
  double ganhos = 95.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Entregador (${entregasProntasGlobais.length} disponíveis)")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS ONLINE/OFFLINE
            Card(
              color: online ? Colors.orange[50] : Colors.grey[200],
              child: SwitchListTile(
                title: Text(online ? "Status: Online (Pronto p/ Corridas)" : "Status: Offline", style: TextStyle(fontWeight: FontWeight.bold)),
                value: online,
                onChanged: (v) => setState(() => online = v),
              ),
            ),
            SizedBox(height: 8),

            // GANHOS E REPUTAÇÃO
            Card(
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.green),
                title: Text("Extrato de Ganhos", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Faturado hoje: R\$ ${ganhos.toStringAsFixed(2)}"),
                onTap: () => _alerta("Ganhos", "Suas entregas de hoje totalizaram R\$ ${ganhos.toStringAsFixed(2)}."),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text("Reputação na Praça", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Nota: 4.9 ⭐ (Excelente)"),
              ),
            ),

            Divider(height: 30),
            Text("Entregas Prontas nas Lojas:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            entregasProntasGlobais.isEmpty
                ? Padding(padding: EdgeInsets.all(20), child: Center(child: Text("Nenhuma corrida no momento.")))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: entregasProntasGlobais.length,
                    itemBuilder: (context, index) {
                      final e = entregasProntasGlobais[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.motorcycle, color: Colors.orange, size: 30),
                          title: Text(e["pedido"], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Rota: ${e["rota"]} • Taxa: ${e["valor"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.map, color: Colors.blue),
                                onPressed: () => _snack("Abrindo rota via GPS..."),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                onPressed: () {
                                  setState(() {
                                    ganhos += 12.00;
                                    entregasProntasGlobais.removeAt(index);
                                  });
                                  _snack("Corrida aceita com sucesso!");
                                },
                                child: Text("Aceitar", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _alerta(String t, String m) => showDialog(context: context, builder: (c) => AlertDialog(title: Text(t), content: Text(m), actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text("OK"))]));
  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
}

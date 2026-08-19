import 'package:flutter/material.dart';

void main() => runApp(MarketplaceApp());

// ================= DADOS GLOBAIS DE INTEGRAÇÃO ENTRE OS SETORES =================
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
              "Selecione o seu perfil de acesso:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 30),
            _buildMenuCard(
              context,
              "Área do Cliente",
              "Ver vitrine, produtos e fazer pedidos",
              Icons.store,
              Colors.green,
              ClienteScreen(),
            ),
            SizedBox(height: 15),
            _buildMenuCard(
              context,
              "Área do Vendedor",
              "Cadastrar e gerenciar produtos da loja",
              Icons.shopping_bag,
              Colors.blue,
              VendedorScreen(),
            ),
            SizedBox(height: 15),
            _buildMenuCard(
              context,
              "Área do Entregador",
              "Ver rotas e pedidos prontos para entrega",
              Icons.delivery_dining,
              Colors.orange,
              EntregadorScreen(),
            ),
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
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "loja": "Açaí do Centro", "estoque": 10, "categoria": "Sobremesas"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "loja": "Pizzaria Bella", "estoque": 5, "categoria": "Alimentação"},
    {"nome": "Hambúrguer Artesanal Completo", "preco": 28.50, "loja": "Burger House", "estoque": 12, "categoria": "Alimentação"},
    {"nome": "Água Mineral 20L", "preco": 12.00, "loja": "Disque Água", "estoque": 20, "categoria": "Mercado"},
  ];

  final List<Map<String, dynamic>> carrinho = [];
  String categoriaFiltro = "Todos";
  String statusPedidoAtual = "Nenhum pedido em andamento";
  String enderecoSalvo = "Rua Principal, 120 - Centro";
  double saldoCashback = 15.50;

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = categoriaFiltro == "Todos" 
        ? produtos 
        : produtos.where((p) => p["categoria"] == categoriaFiltro).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vitrine do Cliente"),
        actions: [
          IconButton(
            icon: Icon(Icons.wallet),
            tooltip: "Carteira / Cashback",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sua Carteira"),
                  content: Text("Saldo de Cashback disponível:\nR\$ ${saldoCashback.toStringAsFixed(2)}\n\nPode ser usado nos próximos pedidos!"),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE ATALHOS SUPERIOR DO CLIENTE
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAtalhoBotao(Icons.motorcycle, "Acompanhar", Colors.orange, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Status do Pedido"),
                          content: Text("Situação atual: $statusPedidoAtual"),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                        ),
                      );
                    }),
                    _buildAtalhoBotao(Icons.star_rate, "Avaliar Loja", Colors.amber, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Avaliar Último Pedido"),
                          content: Text("O que você achou da comida e da entrega?\n\n⭐⭐⭐⭐⭐ (5/5 Estrelas)"),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Enviar Avaliação"))],
                        ),
                      );
                    }),
                    _buildAtalhoBotao(Icons.favorite, "Favoritos", Colors.red, () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Abrindo lojas e itens favoritos...")));
                    }),
                    _buildAtalhoBotao(Icons.local_offer, "Cupons", Colors.green, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Cupons Disponíveis"),
                          content: Text("• PRIMEIRACOMPRA (R\$ 10 OFF)\n• FRETEGRATIS (Nas compras acima de R\$ 50)"),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                        ),
                      );
                    }),
                    _buildAtalhoBotao(Icons.location_on, "Endereço", Colors.blue, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Endereço de Entrega"),
                          content: Text("Atual: $enderecoSalvo"),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                        ),
                      );
                    }),
                    _buildAtalhoBotao(Icons.history, "Pedir de Novo", Colors.purple, () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Carregando último pedido realizado...")));
                    }),
                    _buildAtalhoBotao(Icons.chat, "Chat Loja", Colors.teal, () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Abrindo chat com o vendedor...")));
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // FILTROS DE CATEGORIA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("O que você procura hoje?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ["Todos", "Alimentação", "Sobremesas", "Mercado"].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: categoriaFiltro == cat,
                      onSelected: (bool selected) {
                        setState(() {
                          categoriaFiltro = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Vitrine de Lojas e Produtos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    subtitle: Text("${p["loja"]} - R\$ ${p["preco"].toStringAsFixed(2)} | Estoque: ${p["estoque"]} un."),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        setState(() {
                          carrinho.add(p);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${p["nome"]} adicionado ao carrinho!"), duration: Duration(seconds: 1)),
                        );
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
            Text("Itens no Carrinho: ${carrinho.length}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text("Finalizar Pedido", style: TextStyle(color: Colors.white)),
              onPressed: carrinho.isEmpty ? null : () {
                setState(() {
                  statusPedidoAtual = "Enviado para a Loja";
                  pedidosGlobais.add({
                    "id": "Pedido #${DateTime.now().second}",
                    "itens": carrinho.map((item) => item["nome"]).join(", "),
                    "total": carrinho.fold(0.0, (sum, item) => sum + item["preco"]),
                    "status": "Aguardando Preparo"
                  });
                  carrinho.clear();
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Pedido Realizado com Sucesso!"),
                    content: Text("Seu pedido foi enviado para o Vendedor. Acompanhe o status no botão superior 'Acompanhar'."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtalhoBotao(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
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
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController estoqueController = TextEditingController();
  
  final List<Map<String, dynamic>> meusProdutos = [
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "estoque": 10, "categoria": "Sobremesas"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "estoque": 5, "categoria": "Alimentação"},
  ];
  
  bool lojaAberta = true;
  String tempoPreparo = "30-40 min";
  String categoriaSelecionada = "Alimentação";
  String cupomAtivo = "Nenhum cupom ativo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor (${pedidosGlobais.length} pedidos novos)")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: lojaAberta ? Colors.green[50] : Colors.red[50],
              child: SwitchListTile(
                title: Text(
                  lojaAberta ? "Status: Loja Aberta (Vendendo)" : "Status: Loja Fechada",
                  style: TextStyle(fontWeight: FontWeight.bold, color: lojaAberta ? Colors.green[800] : Colors.red[800]),
                ),
                subtitle: Text("Alterne para abrir ou fechar sua loja no aplicativo"),
                value: lojaAberta,
                onChanged: (bool value) {
                  setState(() {
                    lojaAberta = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // HISTÓRICO DE VENDAS
            Card(
              child: ListTile(
                leading: Icon(Icons.assessment, color: Colors.purple),
                title: Text("Histórico de Vendas", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Total vendido hoje: R\$ 245,00 (8 pedidos)"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Relatório do Dia"),
                      content: Text("Total: R\$ 245,00\nTotal de Pedidos: 8\nTaxas de Entrega: R\$ 48,00"),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                    ),
                  );
                },
              ),
            ),

            // REPUTAÇÃO E AVALIAÇÕES
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber, size: 28),
                title: Text("Reputação e Avaliações", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Nota Média: 4.8 ⭐ (Com base em 45 avaliações)"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Comentários dos Clientes"),
                      content: Text("• 'Comida muito boa e quente!' (5⭐)\n• 'Entrega rápida, recomendo!' (5⭐)"),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                    ),
                  );
                },
              ),
            ),

            // TEMPO DE PREPARO
            Card(
              child: ListTile(
                leading: Icon(Icons.timer, color: Colors.orange),
                title: Text("Tempo de Preparo", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Atual: $tempoPreparo"),
                trailing: Icon(Icons.edit, size: 18),
                onTap: () {
                  setState(() {
                    tempoPreparo = tempoPreparo == "30-40 min" ? "45-60 min" : "30-40 min";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tempo de preparo alterado para $tempoPreparo")),
                  );
                },
              ),
            ),

            // CUPOM
            Card(
              child: ListTile(
                leading: Icon(Icons.local_offer, color: Colors.redAccent),
                title: Text("Criar Cupom / Desconto", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Status: $cupomAtivo"),
                trailing: Icon(Icons.add_box, size: 20, color: Colors.redAccent),
                onTap: () {
                  setState(() {
                    cupomAtivo = cupomAtivo == "Nenhum cupom ativo" ? "PROMO10 (10% OFF)" : "Nenhum cupom ativo";
                  });
                },
              ),
            ),

            Divider(height: 30),

            // PEDIDOS CHEGANDO DO CLIENTE
            Text("Pedidos Recebidos dos Clientes:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            pedidosGlobais.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Nenhum pedido novo no momento. Faça um pedido na aba do Cliente!"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pedidosGlobais.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidosGlobais[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.notifications_active, color: Colors.indigo),
                          title: Text("${pedido["id"]} - R\$ ${pedido["total"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Itens: ${pedido["itens"]}\nStatus: ${pedido["status"]}"),
                          isThreeLine: true,
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            onPressed: () {
                              setState(() {
                                entregasProntasGlobais.add({
                                  "pedido": pedido["id"],
                                  "rota": "Loja ➔ Endereço do Cliente",
                                  "valor": "R\$ 12,00"
                                });
                                pedidosGlobais.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Pedido despachado para os Entregadores!")),
                              );
                            },
                            child: Text("Pronto p/ Entrega", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
                  ),

            Divider(height: 30),

            // GERENCIAR VITRINE
            Text("Gerenciar Vitrine e Estoque", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(controller: nomeController, decoration: InputDecoration(labelText: "Nome do Produto", border: OutlineInputBorder())),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: precoController, decoration: InputDecoration(labelText: "Preço (R\$)", border: OutlineInputBorder()), keyboardType: TextInputType.number),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(controller: estoqueController, decoration: InputDecoration(labelText: "Estoque", border: OutlineInputBorder()), keyboardType: TextInputType.number),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 45)),
              onPressed: () {
                if (nomeController.text.isNotEmpty && precoController.text.isNotEmpty) {
                  setState(() {
                    meusProdutos.add({
                      "nome": nomeController.text,
                      "preco": double.tryParse(precoController.text) ?? 0.0,
                      "estoque": int.tryParse(estoqueController.text) ?? 1,
                      "categoria": categoriaSelecionada,
                    });
                    nomeController.clear();
                    precoController.clear();
                    estoqueController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Produto adicionado com sucesso!")));
                }
              },
              child: Text("Adicionar na Vitrine", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= TELA DO ENTREGADOR =================
class EntregadorScreen extends StatefulWidget {
  @override
  _EntregadorScreenState createState() => _EntregadorScreenState();
}

class _EntregadorScreenState extends State<EntregadorScreen> {
  bool entregadorOnline = true;
  double ganhosHoje = 85.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel de Entregas (${entregasProntasGlobais.length} disponíveis)")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: entregadorOnline ? Colors.orange[50] : Colors.grey[200],
              child: SwitchListTile(
                title: Text(
                  entregadorOnline ? "Entregador Online" : "Entregador Offline",
                  style: TextStyle(fontWeight: FontWeight.bold, color: entregadorOnline ? Colors.orange[800] : Colors.grey[700]),
                ),
                value: entregadorOnline,
                onChanged: (bool value) {
                  setState(() {
                    entregadorOnline = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // GANHOS DO DIA
            Card(
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.green, size: 28),
                title: Text("Meus Ganhos de Hoje", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Total faturado: R\$ ${ganhosHoje.toStringAsFixed(2)}"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Extrato Detalhado"),
                      content: Text("• Corridas finalizadas hoje\n• Gorjetas e taxas inclusas"),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                    ),
                  );
                },
              ),
            ),

            // REPUTAÇÃO
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber, size: 28),
                title: Text("Minha Reputação na Praça", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Nota Média: 4.9 ⭐ (Excelente)"),
                onTap: () {},
              ),
            ),

            Divider(height: 30),

            Text("Entregas Liberadas pelas Lojas:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            entregasProntasGlobais.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Nenhuma entrega disponível. Finalize um pedido no Cliente e aprove no Vendedor!"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: entregasProntasGlobais.length,
                    itemBuilder: (context, index) {
                      final entrega = entregasProntasGlobais[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.motorcycle, color: Colors.orange, size: 30),
                          title: Text(entrega["pedido"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Rota: ${entrega["rota"]}\nTaxa: ${entrega["valor"]}"),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.map, color: Colors.blue),
                                tooltip: "Abrir Rota GPS",
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Abrindo GPS para rota...")),
                                  );
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                onPressed: () {
                                  setState(() {
                                    ganhosHoje += 12.00;
                                    entregasProntasGlobais.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Corrida aceita! Dirija-se ao estabelecimento."), duration: Duration(seconds: 2)),
                                  );
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
}

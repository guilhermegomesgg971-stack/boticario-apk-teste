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

// ================= TELA DO CLIENTE (ATUALIZADA COM OS NOVOS BOTÕES) =================
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

            // FILTROS DE CATEGORIA EM BOTÕES HORIZONTAIS
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

            // LISTA DE PRODUTOS DA VITRINE
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
              onPressed: () {
                setState(() {
                  statusPedidoAtual = "Em preparo na loja";
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Pedido Realizado!"),
                    content: Text("Você tem ${carrinho.length} item(ns). Pedido enviado com sucesso para a loja! Acompanhe pelo botão superior."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
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
  int pedidosRecebidosCount = 2;
  String tempoPreparo = "30-40 min";
  String categoriaSelecionada = "Alimentação";
  String cupomAtivo = "Nenhum cupom ativo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status da Loja
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(lojaAberta ? "Loja aberta com sucesso!" : "Loja fechada para novos pedidos.")),
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            // Botão de Pedidos Recebidos
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: Size(double.infinity, 48),
              ),
              icon: Icon(Icons.notifications_active, color: Colors.white),
              label: Text("Ver Pedidos Recebidos ($pedidosRecebidosCount)", style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Pedidos Chegando"),
                    content: Text("Você possui $pedidosRecebidosCount pedido(s) aguardando aceite e preparo."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fechar"))],
                  ),
                );
              },
            ),
            SizedBox(height: 10),

            // Histórico de Vendas
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

            // Tempo de Preparo
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

            // Criar Cupom / Desconto
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Status do cupom alterado!")),
                  );
                },
              ),
            ),

            // Horário de Funcionamento
            Card(
              child: ListTile(
                leading: Icon(Icons.access_time, color: Colors.blueGrey),
                title: Text("Horário de Funcionamento", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Automático: 18:00 às 23:30"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Horários da Loja"),
                      content: Text("Sua loja está configurada para aceitar pedidos automaticamente das 18h às 23h30."),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                    ),
                  );
                },
              ),
            ),

            // Relatório p/ WhatsApp
            Card(
              child: ListTile(
                leading: Icon(Icons.share, color: Colors.teal),
                title: Text("Relatório p/ WhatsApp", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Enviar resumo do caixa para o dono/gerente"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Resumo copiado para compartilhamento!"), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ),

            // Suporte / Chat
            Card(
              child: ListTile(
                leading: Icon(Icons.chat_bubble, color: Colors.green),
                title: Text("Suporte do Sistema", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Falar com a administração"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Abrindo canal de suporte..."), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ),

            Divider(height: 30),

            // SEÇÃO DE CADASTRO PROFISSIONAL DE PRODUTOS
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
                  child: TextField(controller: estoqueController, decoration: InputDecoration(labelText: "Qtd. em Estoque", border: OutlineInputBorder()), keyboardType: TextInputType.number),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: categoriaSelecionada,
              decoration: InputDecoration(labelText: "Categoria do Produto", border: OutlineInputBorder()),
              items: ["Alimentação", "Bebidas", "Sobremesas", "Serviços/Outros"]
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  categoriaSelecionada = val!;
                });
              },
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Produto adicionado à vitrine com sucesso!")));
                }
              },
              child: Text("Adicionar/Atualizar na Vitrine", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            Divider(height: 30),
            Text("Sua Vitrine Ativa:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meusProdutos.length,
              itemBuilder: (context, index) {
                final prod = meusProdutos[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.fastfood, color: Colors.blue),
                    title: Text(prod["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Preço: R\$ ${prod["preco"].toStringAsFixed(2)} | Estoque: ${prod["estoque"]} un. | [${prod["categoria"]}]"),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          meusProdutos.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Produto removido da vitrine.")));
                      },
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

// ================= TELA DO ENTREGADOR =================
class EntregadorScreen extends StatelessWidget {
  final List<Map<String, String>> entregasDisponiveis = [
    {"pedido": "Pedido #01", "rota": "Centro ➔ Bairro Tres Vendas", "valor": "R\$ 10,00"},
    {"pedido": "Pedido #02", "rota": "Vila Nova ➔ Aldeia", "valor": "R\$ 15,00"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel de Entregas")),
      body: ListView.builder(
        itemCount: entregasDisponiveis.length,
        itemBuilder: (context, index) {
          final entrega = entregasDisponiveis[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.motorcycle, color: Colors.orange, size: 30),
              title: Text(entrega["pedido"]!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Rota: ${entrega["rota"]}\nTaxa: ${entrega["valor"]}"),
              isThreeLine: true,
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Entrega aceita! Navegando..."), duration: Duration(seconds: 2)),
                  );
                },
                child: Text("Aceitar", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}

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

// ================= TELA DO CLIENTE =================
class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final List<Map<String, dynamic>> produtos = [
    {"nome": "Açaí Tradicional 500ml", "preco": 18.00, "loja": "Açaí do Centro"},
    {"nome": "Pizza Marguerita Grande", "preco": 45.00, "loja": "Pizzaria Bella"},
    {"nome": "Hambúrguer Artesanal Completo", "preco": 28.50, "loja": "Burger House"},
  ];

  final List<Map<String, dynamic>> carrinho = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vitrine do Cliente")),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(p["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${p["loja"]} - R\$ ${p["preco"].toStringAsFixed(2)}"),
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Resumo do Pedido"),
                    content: Text("Você tem ${carrinho.length} item(ns) selecionado(s). Total calculado com sucesso!"),
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
}

// ================= TELA DO VENDEDOR (COMPLETA COM OS NOVOS BOTÕES) =================
class VendedorScreen extends StatefulWidget {
  @override
  _VendedorScreenState createState() => _VendedorScreenState();
}

class _VendedorScreenState extends State<VendedorScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final List<String> meusProdutos = ["Açaí Tradicional 500ml", "Pizza Marguerita Grande"];
  
  bool lojaAberta = true;
  int pedidosRecebidosCount = 2;
  String tempoPreparo = "30-40 min";

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

            // NOVO: Histórico de Vendas
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

            // NOVO: Tempo de Preparo
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

            // NOVO: Suporte / Chat
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

            Text("Cadastrar Novo Produto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(controller: nomeController, decoration: InputDecoration(labelText: "Nome do Produto", border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(controller: precoController, decoration: InputDecoration(labelText: "Preço (R\$)", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 45)),
              onPressed: () {
                if (nomeController.text.isNotEmpty) {
                  setState(() {
                    meusProdutos.add(nomeController.text);
                    nomeController.clear();
                    precoController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Produto cadastrado com sucesso!")));
                }
              },
              child: Text("Salvar Produto", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            Divider(height: 30),
            Text("Seus Produtos Ativos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: meusProdutos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.fastfood, color: Colors.blue),
                    title: Text(meusProdutos[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          meusProdutos.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Produto removido do estoque.")));
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

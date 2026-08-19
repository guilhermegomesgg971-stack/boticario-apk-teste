// (Manteremos a estrutura anterior e adicionaremos estas funções no VendedorScreen)

class _VendedorScreenState extends State<VendedorScreen> {
  // ... (variáveis anteriores)
  String tempoPreparo = "30-40 min";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Painel do Vendedor")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ... (Botões anteriores: Status Loja, Pedidos Recebidos)
            
            // NOVO: Histórico de Vendas
            ListTile(
              leading: Icon(Icons.assessment, color: Colors.purple),
              title: Text("Histórico de Vendas"),
              subtitle: Text("Total do dia: R\$ 245,00"),
              onTap: () => _mostrarHistorico(context),
            ),
            
            // NOVO: Tempo de Preparo
            ListTile(
              leading: Icon(Icons.timer, color: Colors.orange),
              title: Text("Tempo de Preparo"),
              subtitle: Text("Atual: $tempoPreparo"),
              onTap: () => _alterarTempoPreparo(context),
            ),

            // NOVO: Botão de Suporte/WhatsApp
            ListTile(
              leading: Icon(Icons.chat_bubble, color: Colors.green),
              title: Text("Suporte / Chat"),
              subtitle: Text("Falar com suporte do app"),
              onTap: () => print("Abrir WhatsApp"),
            ),
            
            // ... (Restante do seu código anterior de produtos)
          ],
        ),
      ),
    );
  }

  void _mostrarHistorico(context) {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text("Vendas do Dia"), content: Text("Total: R\$ 245,00\nPedidos: 8")));
  }

  void _alterarTempoPreparo(context) {
    setState(() {
      tempoPreparo = "45-60 min"; // Exemplo de alteração
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tempo atualizado para $tempoPreparo")));
  }
}

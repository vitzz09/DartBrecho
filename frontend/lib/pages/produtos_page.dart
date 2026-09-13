import 'package:flutter/material.dart';
import '../api_service.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  List<dynamic> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final produtos = await ApiService.listarProdutos();
    setState(() {
      _produtos = produtos;
      _carregando = false;
    });
  }

  Future<void> _excluir(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ApiService.excluirProduto(id);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos cadastrados')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? const Center(child: Text('Nenhum produto cadastrado ainda.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final p = _produtos[index] as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(p['nome'] as String),
                        subtitle: Text(
                          '${p['descricao'] ?? '-'} • R\$ ${(p['preco'] as num).toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _excluir(p['id'] as int),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: ApiService.ehAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/produtos/cadastro');
                _carregar();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

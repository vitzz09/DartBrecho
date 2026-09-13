import 'package:flutter/material.dart';
import '../api_service.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _nomeCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  String? _mensagem;
  bool _carregando = false;

  Future<void> _cadastrar() async {
    setState(() {
      _carregando = true;
      _mensagem = null;
    });

    final erro = await ApiService.cadastrarProduto(
      nome: _nomeCtrl.text,
      descricao: _descricaoCtrl.text,
      preco: _precoCtrl.text,
    );

    setState(() => _carregando = false);

    if (erro == null) {
      if (mounted) Navigator.pop(context); // volta pro painel/produtos
    } else {
      setState(() => _mensagem = erro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar produto')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome da peça'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoCtrl,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _precoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Preço (ex: 39.90)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                if (_mensagem != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_mensagem!, style: const TextStyle(color: Colors.red)),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    child: _carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

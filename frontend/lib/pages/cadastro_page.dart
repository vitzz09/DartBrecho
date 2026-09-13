import 'package:flutter/material.dart';
import '../api_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  String? _mensagem;
  bool _erro = false;
  bool _carregando = false;

  Future<void> _cadastrar() async {
    setState(() {
      _carregando = true;
      _mensagem = null;
    });

    final resultado = await ApiService.cadastro(
      nome: _nomeCtrl.text,
      email: _emailCtrl.text,
      senha: _senhaCtrl.text,
    );

    setState(() {
      _carregando = false;
      _erro = resultado['erro'] != null;
      _mensagem = (resultado['erro'] ?? resultado['mensagem']) as String?;
    });

    if (!_erro && mounted) {
      Navigator.pop(context); // volta pra tela de login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
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
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _senhaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Senha (mín. 6 caracteres)',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (_mensagem != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _mensagem!,
                      style: TextStyle(color: _erro ? Colors.red : Colors.green),
                    ),
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

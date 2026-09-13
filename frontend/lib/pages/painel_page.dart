import 'package:flutter/material.dart';
import '../api_service.dart';

class PainelPage extends StatelessWidget {
  const PainelPage({super.key});

  Future<void> _sair(BuildContext context) async {
    await ApiService.logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bem-vindo(a), ${ApiService.nomeUsuario}! 👋',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/produtos'),
                child: const Text('Ver produtos'),
              ),
              if (ApiService.ehAdmin) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/produtos/cadastro'),
                  child: const Text('Cadastrar produto'),
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => _sair(context),
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

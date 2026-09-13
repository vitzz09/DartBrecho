import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/painel_page.dart';
import 'pages/produtos_page.dart';
import 'pages/cadastro_produto_page.dart';

void main() {
  runApp(const BrechoApp());
}

class BrechoApp extends StatelessWidget {
  const BrechoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFFA8562F);

    return MaterialApp(
      title: 'Brechó da Vila',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDF6EC),
        colorScheme: ColorScheme.fromSeed(seedColor: corPrincipal),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrincipal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/painel': (context) => const PainelPage(),
        '/produtos': (context) => const ProdutosPage(),
        '/produtos/cadastro': (context) => const CadastroProdutoPage(),
      },
    );
  }
}

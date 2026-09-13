import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../lib/auth.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = context.read<Database>();
  final token = extrairToken(context.request.headers);
  final usuario = token == null ? null : usuarioPorToken(db, token);

  if (usuario == null) {
    return Response.json(statusCode: 401, body: {'erro': 'Não autenticado.'});
  }

  // ---------- LISTAR (qualquer usuário logado) ----------
  if (context.request.method == HttpMethod.get) {
    final produtos = db.select(
      'SELECT id, nome, descricao, preco FROM produtos ORDER BY id DESC',
    );
    return Response.json(
      body: produtos
          .map((p) => {
                'id': p['id'],
                'nome': p['nome'],
                'descricao': p['descricao'],
                'preco': p['preco'],
              })
          .toList(),
    );
  }

  // ---------- CADASTRAR (só admin) ----------
  if (context.request.method == HttpMethod.post) {
    if (usuario['admin'] != 1) {
      return Response.json(
        statusCode: 403,
        body: {'erro': 'Só administradores podem cadastrar produtos.'},
      );
    }

    final corpo = await context.request.json() as Map<String, dynamic>;
    final nome = (corpo['nome'] ?? '').toString().trim();
    final descricao = (corpo['descricao'] ?? '').toString().trim();
    final preco = double.tryParse(
      corpo['preco'].toString().replaceAll(',', '.'),
    );

    if (nome.isEmpty || preco == null) {
      return Response.json(
        statusCode: 400,
        body: {'erro': 'Preencha nome e preço corretamente.'},
      );
    }

    db.execute(
      'INSERT INTO produtos (nome, descricao, preco, criado_por) VALUES (?, ?, ?, ?)',
      [nome, descricao, preco, usuario['id']],
    );
    return Response.json(body: {'sucesso': true});
  }

  return Response(statusCode: 405);
}

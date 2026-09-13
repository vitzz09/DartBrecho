import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../lib/auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Método não permitido.');
  }

  final db = context.read<Database>();
  final corpo = await context.request.json() as Map<String, dynamic>;

  final nome = (corpo['nome'] ?? '').toString().trim();
  final email = (corpo['email'] ?? '').toString().trim().toLowerCase();
  final senha = (corpo['senha'] ?? '').toString();

  if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'erro': 'Preencha todos os campos.'},
    );
  }

  if (senha.length < 6) {
    return Response.json(
      statusCode: 400,
      body: {'erro': 'A senha precisa ter pelo menos 6 caracteres.'},
    );
  }

  final senhaHash = hashSenha(senha);

  try {
    db.execute(
      'INSERT INTO usuarios (nome, email, senha_hash) VALUES (?, ?, ?)',
      [nome, email, senhaHash],
    );
    return Response.json(body: {
      'sucesso': true,
      'mensagem': 'Cadastro feito! Agora faça login.',
    });
  } on SqliteException catch (e) {
    if (e.message.contains('UNIQUE')) {
      return Response.json(
        statusCode: 400,
        body: {'erro': 'Esse email já está cadastrado.'},
      );
    }
    return Response.json(statusCode: 500, body: {'erro': 'Erro no servidor.'});
  }
}

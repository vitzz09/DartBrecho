import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../lib/auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Método não permitido.');
  }

  final db = context.read<Database>();
  final corpo = await context.request.json() as Map<String, dynamic>;

  final email = (corpo['email'] ?? '').toString().trim().toLowerCase();
  final senha = (corpo['senha'] ?? '').toString();

  final resultado = db.select(
    'SELECT * FROM usuarios WHERE email = ?',
    [email],
  );

  // Mensagem sempre igual, propositalmente — não dizemos se foi
  // o email ou a senha que errou.
  const erroGenerico = 'Email ou senha incorretos.';

  if (resultado.isEmpty) {
    return Response.json(statusCode: 401, body: {'erro': erroGenerico});
  }

  final usuario = resultado.first;

  if (!senhaCorreta(senha, usuario['senha_hash'] as String)) {
    return Response.json(statusCode: 401, body: {'erro': erroGenerico});
  }

  final token = gerarToken();
  db.execute(
    'INSERT INTO sessoes (token, usuario_id, criado_em) VALUES (?, ?, ?)',
    [token, usuario['id'], DateTime.now().toIso8601String()],
  );

  return Response.json(body: {
    'sucesso': true,
    'token': token,
    'nome': usuario['nome'],
    'admin': usuario['admin'] == 1,
  });
}

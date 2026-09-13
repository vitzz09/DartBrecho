import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../lib/auth.dart';

Response onRequest(RequestContext context) {
  final db = context.read<Database>();
  final token = extrairToken(context.request.headers);

  if (token == null) {
    return Response.json(statusCode: 401, body: {'erro': 'Não autenticado.'});
  }

  final usuario = usuarioPorToken(db, token);
  if (usuario == null) {
    return Response.json(statusCode: 401, body: {'erro': 'Sessão inválida.'});
  }

  return Response.json(body: {
    'nome': usuario['nome'],
    'admin': usuario['admin'] == 1,
  });
}

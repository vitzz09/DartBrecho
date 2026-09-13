import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../lib/auth.dart';

// O "id" aqui vem do nome do arquivo: [id].dart. Dart Frog
// entende automaticamente que /produtos/5 deve chamar essa
// função passando id = "5".
Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.delete) {
    return Response(statusCode: 405);
  }

  final db = context.read<Database>();
  final token = extrairToken(context.request.headers);
  final usuario = token == null ? null : usuarioPorToken(db, token);

  if (usuario == null) {
    return Response.json(statusCode: 401, body: {'erro': 'Não autenticado.'});
  }

  // Conforme combinado: qualquer usuário logado pode excluir,
  // não precisa ser admin.
  final idNumero = int.tryParse(id);
  if (idNumero == null) {
    return Response.json(statusCode: 400, body: {'erro': 'ID inválido.'});
  }

  db.execute('DELETE FROM produtos WHERE id = ?', [idNumero]);
  return Response.json(body: {'sucesso': true});
}

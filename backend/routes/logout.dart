import 'package:dart_frog/dart_frog.dart';
import 'package:sqlite3/sqlite3.dart';

import '../lib/auth.dart';

Response onRequest(RequestContext context) {
  final db = context.read<Database>();
  final token = extrairToken(context.request.headers);

  if (token != null) {
    db.execute('DELETE FROM sessoes WHERE token = ?', [token]);
  }

  return Response.json(body: {'sucesso': true});
}

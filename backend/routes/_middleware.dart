// ============================================================
// ROUTES/_MIDDLEWARE.DART — roda antes de TODAS as rotas
// ============================================================
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mime/mime.dart';
import 'package:sqlite3/sqlite3.dart';

import '../lib/db.dart';

Handler middleware(Handler handler) {
  return handler
      .use(provider<Database>((_) => getDb()))
      .use(_cors())
      .use(_arquivosEstaticos());
}

Middleware _cors() {
  const cabecalhos = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
  };

  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(headers: cabecalhos);
      }
      final resposta = await handler(context);
      return resposta.copyWith(headers: {...resposta.headers, ...cabecalhos});
    };
  };
}

// Se nenhuma rota da API bateu com o pedido (ou seja, o
// resultado seria um 404), tentamos servir um arquivo estático
// do Flutter Web em vez de devolver "não encontrado".
Middleware _arquivosEstaticos() {
  return (handler) {
    return (context) async {
      final resposta = await handler(context);

      // Se alguma rota real respondeu, não mexe em nada.
      if (resposta.statusCode != 404) return resposta;

      final caminho = context.request.url.path;
      final nomeArquivo = caminho.isEmpty ? 'index.html' : caminho;

      var arquivo = File('public/$nomeArquivo');
      if (!arquivo.existsSync()) {
        arquivo = File('public/index.html');
      }
      if (!arquivo.existsSync()) {
        return resposta; // devolve o 404 original mesmo
      }

      final bytes = await arquivo.readAsBytes();
      final tipoMime = lookupMimeType(arquivo.path) ?? 'application/octet-stream';
      return Response.bytes(body: bytes, headers: {'Content-Type': tipoMime});
    };
  };
}
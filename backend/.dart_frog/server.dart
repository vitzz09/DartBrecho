// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/painel.dart' as painel;
import '../routes/logout.dart' as logout;
import '../routes/login.dart' as login;
import '../routes/cadastro.dart' as cadastro;
import '../routes/produtos/index.dart' as produtos_index;
import '../routes/produtos/[id].dart' as produtos_$id;
import '../routes/api/status.dart' as api_status;
import '../routes/.dart_frog/server.dart' as dart_frog_server;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(createStaticFileHandler()).add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/', (context) => buildHandler()(context))
    ..mount('/produtos', (context) => buildProdutosHandler()(context))
    ..mount('/api', (context) => buildApiHandler()(context))
    ..mount('/.dart_frog', (context) => buildDartFrogHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/cadastro', (context) => cadastro.onRequest(context,))..all('/login', (context) => login.onRequest(context,))..all('/logout', (context) => logout.onRequest(context,))..all('/painel', (context) => painel.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildProdutosHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => produtos_$id.onRequest(context,id,))..all('/', (context) => produtos_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/status', (context) => api_status.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildDartFrogHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => dart_frog_server.onRequest(context,));
  return pipeline.addHandler(router);
}


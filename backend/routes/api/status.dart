import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(body: {
    'status': 'ok',
    'mensagem': 'API do brechó rodando em Dart Frog 🎉',
  });
}

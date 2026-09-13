// ============================================================
// LIB/AUTH.DART — funções reutilizadas nas rotas de login
// ============================================================

// CREDENCIAIS TESTES
//teste@teste.com 123456
import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:sqlite3/sqlite3.dart';

/// Transforma a senha em um hash irreversível — nunca guardamos
/// a senha original, exatamente como fizemos em Node e Python.
String hashSenha(String senha) => BCrypt.hashpw(senha, BCrypt.gensalt());

/// Compara a senha digitada com o hash salvo no banco.
bool senhaCorreta(String senha, String hash) => BCrypt.checkpw(senha, hash);

/// Gera um token aleatório e imprevisível para representar a
/// sessão do usuário (o "crachá" que ele vai apresentar em cada
/// requisição depois de logar).
String gerarToken() {
  final aleatorio = Random.secure();
  final bytes = List<int>.generate(32, (_) => aleatorio.nextInt(256));
  return base64Url.encode(bytes);
}

/// Extrai o token do cabeçalho "Authorization: Bearer XXXXX".
String? extrairToken(Map<String, String> headers) {
  final valor = headers['authorization'];
  if (valor == null || !valor.startsWith('Bearer ')) return null;
  return valor.substring(7);
}

/// Busca no banco o usuário dono do token, ou null se o token
/// não existir (sessão inválida ou expirada).
Row? usuarioPorToken(Database db, String token) {
  final resultado = db.select('''
    SELECT usuarios.id, usuarios.nome, usuarios.admin
    FROM sessoes
    JOIN usuarios ON usuarios.id = sessoes.usuario_id
    WHERE sessoes.token = ?
  ''', [token]);

  return resultado.isEmpty ? null : resultado.first;
}

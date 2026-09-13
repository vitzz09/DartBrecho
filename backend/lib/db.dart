// ============================================================
// LIB/DB.DART — abre o banco SQLite e cria as tabelas
// ============================================================
// Mesma ideia do projeto em Flask: um arquivo .db local, duas
// tabelas (usuarios e produtos) e uma terceira nova (sessoes),
// porque em Dart Frog não existe "session" pronta como no
// Flask — nós mesmos guardamos um token por usuário logado.

import 'package:sqlite3/sqlite3.dart';

Database? _instancia;

Database getDb() {
  // Só abre o arquivo uma vez e reutiliza a conexão depois.
  _instancia ??= _abrirEIniciar();
  return _instancia!;
}

Database _abrirEIniciar() {
  final db = sqlite3.open('brecho.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      senha_hash TEXT NOT NULL,
      admin INTEGER NOT NULL DEFAULT 0
    )
  ''');

  db.execute('''
    CREATE TABLE IF NOT EXISTS sessoes (
      token TEXT PRIMARY KEY,
      usuario_id INTEGER NOT NULL,
      criado_em TEXT NOT NULL,
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
    )
  ''');

  db.execute('''
    CREATE TABLE IF NOT EXISTS produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      preco REAL NOT NULL,
      criado_por INTEGER,
      FOREIGN KEY (criado_por) REFERENCES usuarios (id)
    )
  ''');

  return db;
}

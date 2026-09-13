// ============================================================
// API_SERVICE.DART — toda a comunicação com o backend fica aqui
// ============================================================
// Diferente do Flask (que guardava a sessão num cookie
// automático), aqui o Flutter guarda o "token" na memória e
// manda ele em todo pedido, no cabeçalho Authorization.
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Se você rodar o backend em outra porta, mude aqui.
  static const String baseUrl = 'http://localhost:8080';

  // Guardado só na memória: se a pessoa fechar a aba, perde a
  // sessão. Isso é intencional pra manter o exemplo simples.
  static String? token;
  static String? nomeUsuario;
  static bool ehAdmin = false;

  static bool get estaLogado => token != null;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<Map<String, dynamic>> cadastro({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/cadastro'),
      headers: _headers,
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Retorna null se deu certo, ou a mensagem de erro se falhou.
  static Future<String?> login({
    required String email,
    required String senha,
  }) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'senha': senha}),
    );
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

    if (resposta.statusCode == 200) {
      token = dados['token'] as String;
      nomeUsuario = dados['nome'] as String;
      ehAdmin = dados['admin'] == true;
      return null;
    }
    return dados['erro'] as String? ?? 'Erro desconhecido.';
  }

  static Future<void> logout() async {
    await http.post(Uri.parse('$baseUrl/logout'), headers: _headers);
    token = null;
    nomeUsuario = null;
    ehAdmin = false;
  }

  static Future<List<dynamic>> listarProdutos() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl/produtos'),
      headers: _headers,
    );
    return jsonDecode(resposta.body) as List<dynamic>;
  }

  static Future<String?> cadastrarProduto({
    required String nome,
    required String descricao,
    required String preco,
  }) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: _headers,
      body: jsonEncode({'nome': nome, 'descricao': descricao, 'preco': preco}),
    );
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    if (resposta.statusCode == 200) return null;
    return dados['erro'] as String? ?? 'Erro ao cadastrar.';
  }

  static Future<void> excluirProduto(int id) async {
    await http.delete(Uri.parse('$baseUrl/produtos/$id'), headers: _headers);
  }
}

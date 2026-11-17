import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/umkm.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.errors = const {}});

  final String message;
  final Map<String, dynamic> errors;

  @override
  String toString() => message;
}

class UmkmApi {
  UmkmApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          (baseUrl ??
                  const String.fromEnvironment(
                    'API_BASE_URL',
                    defaultValue: 'http://10.0.2.2:8080/api',
                  ))
              .replaceFirst(RegExp(r'/+$'), '');

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_baseUrl/$path').replace(queryParameters: query);

  Future<List<Umkm>> list({int page = 1, int perPage = 10}) async {
    final json = await _send(
      'GET',
      _uri('umkm', {'page': '$page', 'per_page': '$perPage'}),
    );
    return (json['data'] as List<dynamic>)
        .map((item) => Umkm.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Umkm> create(Umkm item) async {
    final json = await _send('POST', _uri('umkm'), body: item.toJson());
    return Umkm.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Umkm> update(Umkm item) async {
    final json = await _send(
      'PUT',
      _uri('umkm/${item.id}'),
      body: item.toJson(),
    );
    return Umkm.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _send('DELETE', _uri('umkm/$id'));
  }

  Future<Map<String, dynamic>> _send(
    String method,
    Uri uri, {
    Map<String, dynamic>? body,
  }) async {
    final request = http.Request(method, uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'application/json';
    if (body != null) request.body = jsonEncode(body);

    final streamed = await _client
        .send(request)
        .timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamed);
    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException('Server mengirim respons yang bukan JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Format respons API tidak sesuai.');
    }
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      final rawErrors = decoded['errors'];
      throw ApiException(
        decoded['message'] as String? ??
            'Request gagal (${response.statusCode}).',
        errors: rawErrors is Map<String, dynamic> ? rawErrors : const {},
      );
    }
    return decoded;
  }

  void close() => _client.close();
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://localhost:3001';
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  ApiService(); // Parameterless constructor

  /// Generic request method
  /// T = expected response type
  /// U = request body type
  Future<T> request<T, U>({
    required String endpoint,
    required String method,
    U? body, // renamed from fromJson to body, JS-style
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) parser, // convert JSON to T
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final combinedHeaders = {..._defaultHeaders, ...?headers};

 print('method: $method uri: $uri');

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        final uriWithParams = body != null
            ? uri.replace(
                queryParameters: (body as Map<String, dynamic>)
                    .map((k, v) => MapEntry(k, v.toString())),
              )
            : uri;
        response = await http.get(uriWithParams, headers: combinedHeaders);
        break;

      case 'POST':
        response = await http.post(
          uri,
          headers: combinedHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      case 'PUT':
        response = await http.put(
          uri,
          headers: combinedHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      case 'DELETE':
        response = await http.delete(
          uri,
          headers: combinedHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      case 'PATCH':
        response = await http.patch(
          uri,
          headers: combinedHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Request failed [${response.statusCode}]: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return parser(jsonResponse);
  }

  // GET request for returning a List ???
  // not sure if this is actually needed hehe

  /// Helper for GET requests that return a list
  // Future<List<T>> requestList<T, U>({
  //   required String endpoint,
  //   U? body,
  //   Map<String, String>? headers,
  //   required T Function(Map<String, dynamic>) parser,
  // }) async {
  //   final uri = Uri.parse('$_baseUrl$endpoint');
  //   final combinedHeaders = {..._defaultHeaders, ...?headers};

  //   final uriWithParams = body != null
  //       ? uri.replace(
  //           queryParameters:
  //               (body as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString())),
  //         )
  //       : uri;

  //   final response = await http.get(uriWithParams, headers: combinedHeaders);

  //   if (response.statusCode < 200 || response.statusCode >= 300) {
  //     throw Exception(
  //         'Request failed [${response.statusCode}]: ${response.body}');
  //   }

  //   final jsonList = jsonDecode(response.body) as List<dynamic>;
  //   return jsonList.map((item) => parser(item as Map<String, dynamic>)).toList();
  // }
}

import 'dart:convert';
// import 'dart:math';
import 'package:http/http.dart' as http;
// import 'dart:developer' as developer;
import 'package:vivo_front/types/categories.dart';


class ApiService {
  final String _baseUrl = 'http://10.0.0.195:3001';
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  ApiService(); // Parameterless constructor

// ------------
// Request method - POST, PUT/PATCH, DELETE
// No specificed return type... just the message object from golang server
// 
Future<ResponseMessage> request({
  required String endpoint,
  required String method,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
}) async {
  final uri = Uri.parse('$_baseUrl$endpoint');
  final combinedHeaders = {..._defaultHeaders, ...?headers};

  http.Response response;

  switch (method.toUpperCase()) {
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
      'Request failed [${response.statusCode}]: ${response.body}',
    );
  }

  // Decode JSON into ResponseMessage
  final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
  return ResponseMessage.fromJson(json);
}


// ---------------------------------------------
// GET method
// Returns specified T generic type...
// 
// 
  Future<T> requestList<T>({
    required String endpoint,
    Map<String, String>? headers,
    required T Function(dynamic) parser,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final combinedHeaders = {..._defaultHeaders, ...?headers};

    final response = await http.get(uri, headers: combinedHeaders);

    // developer.log("printer;GET returned response: $response", name:'vivo-loggy', level: 0);
    print(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed [${response.statusCode}]: ${response.body}',
      );
    }

    // Decode the body as a Map
    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;


    return parser(json); // this is exactly what you want
  }
}

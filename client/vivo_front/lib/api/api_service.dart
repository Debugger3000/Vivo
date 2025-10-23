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
// GET method for LISTS
// Returns specified T generic type...
// 
// 
  Future<List<T>> requestList<T>({
    required String endpoint,
    Map<String, String>? headers,
    required T Function(dynamic) parser,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final combinedHeaders = {..._defaultHeaders, ...?headers};

    final response = await http.get(uri, headers: combinedHeaders);

    // developer.log("printer;GET returned response: $response", name:'vivo-loggy', level: 0);
    

    // Check for 200
    if (response.statusCode >= 300) {
      throw Exception(
        'Request failed [${response.statusCode}]: ${response.body}',
      );
    }
    else{
      // return GetEventPreview.fromJson(jsonDecode(response.body)) as List<dynamic>;
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      print(jsonList.length);
      return jsonList.map((item) => parser(item)).toList();
    }


  }


  // -------------------------
// GET -  single item get

Future<T> requestSingle<T>({
  required String endpoint,
  Map<String, String>? headers,
  required T Function(dynamic) parser,
}) async {
  final uri = Uri.parse('$_baseUrl$endpoint');
  final combinedHeaders = {..._defaultHeaders, ...?headers};

  final response = await http.get(uri, headers: combinedHeaders);

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
      'Request failed [${response.statusCode}]: ${response.body}',
    );
  }

  final dynamic jsonData = jsonDecode(response.body);

  // If the server returns a list with one element, safely unwrap it
  if (jsonData is List && jsonData.isNotEmpty) {
    return parser(jsonData.first);
  }

  // Otherwise, assume it’s a single JSON object
  return parser(jsonData);
  }


  // Delete something....
  /// Makes a DELETE request to the given endpoint.
  Future<bool> requestDelete({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final combinedHeaders = {..._defaultHeaders, ...?headers};

    try {
      final response = await http.delete(uri, headers: combinedHeaders);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print(
            'DELETE failed [${response.statusCode}]: ${response.body}'); // optional logging
        return false;
      }
    } catch (e) {
      print('DELETE request error: $e');
      return false;
    }
  }



} // end of class.....




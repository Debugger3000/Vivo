

// fetch categories from DB
  import 'package:vivo_front/api/api_service.dart';

Future<List<String>> getCategories(ApiService api) async {
    try {
      print('calling get on categories...');
      final categories = await api.requestList<String>(
        endpoint: '/api/categories',
        parser: (item) => item as String,
      );
      print("returned GET data: $categories");

      
         // IMPORTANT: setState() should be used to update UI / core to flutter/dart lifecycle...
        return categories;
      
    } catch (e) {
      print('error: $e');
      return [];
    } 
  }
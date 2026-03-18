


 import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/event.dart';

Future<List<GetEventPreview>> getEvents(ApiService api) async {
    try {
      print('calling get events');
      final events = await api.requestList<GetEventPreview>(
        endpoint: '/api/events-preview',
        parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
      );
      //print(events.length);
      //print(events);
      return events;
    } catch (e) {
      print('Error in get_Events API: $e');
      return [];
    } 
  }


  Future<List<GetEventPreview>> getEventsByTitle(ApiService api, String title) async {
  try {
    // We encode the title to handle spaces and special characters safely
    final String query = Uri.encodeComponent(title);
    
    final events = await api.requestList<GetEventPreview>(
      endpoint: '/api/events-search?title=$query',
      parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
    );
    
    return events;
  } catch (e) {
    print('Error fetching events by title: $e');
    return [];
  }
}


  Future<List<GetEventPreview>> getEventsByCategory(ApiService api, String category) async {
  try {
    // We encode the category name (e.g., 'Food & Drink' becomes 'Food%20%26%20Drink')
    final String query = Uri.encodeComponent(category);

    final events = await api.requestList<GetEventPreview>(
      endpoint: '/api/events-search?categories=$query',
      parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
    );
    
    return events;
  } catch (e) {
    print('Error fetching events by category: $e');
    return [];
  }
}
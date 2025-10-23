


 import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/event.dart';

Future<List<GetEventPreview>> getEvents(ApiService api) async {
    try {
      print('calling get events');
      final events = await api.requestList<GetEventPreview>(
        endpoint: '/api/events-preview',
        parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
      );
      print(events.length);
      return events;
    } catch (e) {
      print('Error on getEvents in event.dart: $e');
      return [];
    } 
  }
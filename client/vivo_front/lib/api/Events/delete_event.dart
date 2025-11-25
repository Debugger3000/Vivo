 import 'package:vivo_front/api/api_service.dart';

Future<bool> deleteEvent(ApiService api, String eventId) async {
    try {
      print('deleting an event');
      final result = await api.requestDelete(
        endpoint: '/api/events/$eventId',
      );
      return result;
    } catch (e) {
      print('Error on delete event: $e');
      return false;
    }
  }
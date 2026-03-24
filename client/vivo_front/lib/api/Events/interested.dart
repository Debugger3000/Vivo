import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/categories.dart';

Future<ResponseMessage?> toggleEventInterest(ApiService api, String eventId, String userId) async {
  try {
    // We pass the IDs in the body Map, which your wrapper jsonEncodes automatically
    final response = await api.request(
      endpoint: '/api/events-interested',
      method: 'POST',
      body: {
        'eventId': eventId,
        'userId': userId,
      },
    );

    return response;
  } catch (e) {
    print('Error updating event interest: $e');
    // Depending on your UI, you might want to re-throw or return a custom error message
    return null; 
  }
}

Future<ResponseMessage?> toggleEventInterestUnClick(ApiService api, String eventId, String userId) async {
  try {
    // We pass the IDs in the body Map, which your wrapper jsonEncodes automatically
    final response = await api.request(
      endpoint: '/api/events-uninterested',
      method: 'POST',
      body: {
        'eventId': eventId,
        'userId': userId,
      },
    );

    return response;
  } catch (e) {
    print('Error updating event interest: $e');
    // Depending on your UI, you might want to re-throw or return a custom error message
    return null; 
  }
}

Future<bool> checkEventInterest(ApiService api, String eventId, String userId) async {
  try {
    final ResponseMessage response = await api.request(
      endpoint: '/api/events-interested-check',
      method: 'POST',
      body: {'eventId': eventId, 'userId': userId},
    );

    // Access the dynamic 'data' map we added to the class
    if (response.data != null) {
      return response.data!['isInterested'] == true;
    }
    
    return false;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}



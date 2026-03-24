class EventVivo {
  final String userId;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> categories;
  final String date;
  final String eventImage;

  EventVivo({
    required this.userId,
    required this.title,
    required this.description,
    required this.tags,
    required this.categories,
    required this.date,
    required this.eventImage,
  });

  factory EventVivo.fromJson(Map<String, dynamic> json) {
    return EventVivo(
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: json['tags'] as List<String>,
      categories: json['categories'] as List<String>,
      date: json['date'] as String,
      eventImage: json['eventImage'] as String,
    );
  }
}


// Event - GET preview
// For map markers + preview card
class GetEventPreview {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String createdAt;
  final String startTime;
  final String endTime;
  final double latitude;
  final double longitude;
  final int interested;
  final List<String> tags;
  final List<String> categories;
  final String address;
  final String eventImage;


  GetEventPreview({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.startTime,
    required this.endTime,
    required this.latitude,
    required this.longitude,
    this.interested = 0,
    this.tags = const [],
    this.categories = const [],
    required this.address,
    required this.eventImage
  });

  factory GetEventPreview.fromJson(Map<String, dynamic> json) {
    return GetEventPreview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      interested: (json['interested'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      address: json['address'] as String,
      eventImage: json['eventImage'] as String,
    );
  }
}



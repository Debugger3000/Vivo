class EventVivo {
  final String userId;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> categories;
  final String date;

  EventVivo({
    required this.userId,
    required this.title,
    required this.description,
    required this.tags,
    required this.categories,
    required this.date,
  });

  factory EventVivo.fromJson(Map<String, dynamic> json) {
    return EventVivo(
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: json['tags'] as List<String>,
      categories: json['categories'] as List<String>,
      date: json['date'] as String,
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
  final String date;
  final double latitude;
  final double longitude;
  final int interested;
  final List<String> tags;
  final List<String> categories;

  GetEventPreview({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
    this.interested = 0,
    this.tags = const [],
    this.categories = const [],
  });

  factory GetEventPreview.fromJson(Map<String, dynamic> json) {
    return GetEventPreview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
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
    );
  }
}



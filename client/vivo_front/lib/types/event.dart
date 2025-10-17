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

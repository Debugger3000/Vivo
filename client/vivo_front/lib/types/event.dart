class EventVivo {
  final int id;
  final int userId;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> categories;
  final String date;

  EventVivo({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.tags,
    required this.categories,
    required this.date,
  });

  factory EventVivo.fromJson(Map<String, dynamic> json) {
    return EventVivo(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: json['tags'] as List<String>,
      categories: json['categories'] as List<String>,
      date: json['date'] as String,
    );
  }
}

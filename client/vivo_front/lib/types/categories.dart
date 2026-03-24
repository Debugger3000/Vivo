// class Categories {
//   final List<String> categoriesArray;

//   Categories({required this.categoriesArray});

//   factory Categories.fromJson(Map<String, dynamic> json) {
//     return Categories(
//       categoriesArray: List<String>.from(json['categoriesArray'] ?? []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'categoriesArray': categoriesArray};
//   }
// }

class Categories {
  final List<String> categories;

  Categories({
    required this.categories,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    final raw = json['categories'] as List<dynamic>; // raw array
    return Categories(
      categories: raw.map((e) => e as String).toList(),
    );
  }
}



// POST return type

// class ResponseMessage {
//   final String message;

//   ResponseMessage({required this.message});

//   factory ResponseMessage.fromJson(Map<String, dynamic> json) {
//     return ResponseMessage(
//       message: json['message'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//     };
//   }
// }

class ResponseMessage {
  final String message;
  final bool success; // Optional: good for status checks
  final Map<String, dynamic>? data; // This captures the "extra" stuff

  ResponseMessage({
    required this.message,
    this.success = true,
    this.data,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? true,
      // Store the whole JSON map here so you can access ANY field later
      data: json, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      ...?(data), // Merges the dynamic data back in
    };
  }
}

// enums for categories...
const List<String> categoriesEnum = [
  'Alcohol',
  'Sports',
  'Entertainment',
  'Food',
  'Gaming'
];

// education, music

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

class ResponseMessage {
  final String message;

  ResponseMessage({required this.message});

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
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

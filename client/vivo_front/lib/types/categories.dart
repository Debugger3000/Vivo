

class Categories {
  final List<String> categoriesArray;

  Categories({required this.categoriesArray});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categoriesArray: List<String>.from(json['categoriesArray'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoriesArray': categoriesArray,
    };
  }
}

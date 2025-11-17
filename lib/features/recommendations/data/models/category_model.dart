class CategoryModel {
  final String id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(String id, Map<String, dynamic> json) {
    return CategoryModel(
      id: id,
      name: json['name'] as String? ?? 'Nome Indefinido',
    );
  }
}
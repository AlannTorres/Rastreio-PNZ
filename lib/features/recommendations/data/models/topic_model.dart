class TopicModel {
  final String title;
  final String rationale;
  final String clinical;
  final String other;
  final String discussion;
  final List<String> toolIds;
  final List<String> categories;

  TopicModel({
    required this.title,
    required this.rationale,
    required this.clinical,
    required this.other,
    required this.discussion,
    required this.toolIds,
    required this.categories, 
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    return TopicModel(
      title: json['title'] as String? ?? '',
      rationale: json['rationale'] as String? ?? '',
      clinical: json['clinical'] as String? ?? '',
      other: json['other'] as String? ?? '',
      discussion: json['discussion'] as String? ?? '',
      toolIds: parseStringList(json['tool']),
      categories: parseStringList(json['categories']),
    );
  }
}
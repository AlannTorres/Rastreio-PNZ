class ToolModel {
  final String url;
  final String title;
  final String text;

  ToolModel({
    required this.url,
    required this.title,
    required this.text,
  });

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}
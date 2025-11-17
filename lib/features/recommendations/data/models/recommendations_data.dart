import 'recommendation_model.dart';

class RecommendationsData {
  final String note;
  final String lastUpdated;
  final String lastUpdatedText;
  final List<RecommendationModel> specificRecommendations;

  RecommendationsData({
    required this.note,
    required this.lastUpdated,
    required this.lastUpdatedText,
    required this.specificRecommendations,
  });

  factory RecommendationsData.fromJson(Map<String, dynamic> json) {
    return RecommendationsData(
      note: json['note'] as String,
      lastUpdated: json['lastUpdated'] as String,
      lastUpdatedText: json['lastUpdatedText'] as String,
      specificRecommendations: (json['specificRecommendations'] as List<dynamic>)
          .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'lastUpdated': lastUpdated,
      'lastUpdatedText': lastUpdatedText,
      'specificRecommendations': specificRecommendations.map((e) => e.toJson()).toList(),
    };
  }
}

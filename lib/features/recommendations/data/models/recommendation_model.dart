import '../../domain/entities/recommendation.dart';

class RecommendationModel extends Recommendation {
  RecommendationModel({
    required super.id,
    required super.title,
    required super.grade,
    required super.gradeVer,
    required super.gender,
    required super.sex,
    required super.ageRange,
    required super.text,
    required super.servFreq,
    required super.riskName,
    required super.risk,
    required super.riskText,
    required super.general,
    required super.tool,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      grade: json['grade'] as String,
      gradeVer: json['gradeVer'] as int,
      gender: json['gender'] as String,
      sex: json['sex'] as String,
      ageRange: (json['ageRange'] as List<dynamic>).map((e) => e as int).toList(),
      text: json['text'] as String,
      servFreq: json['servFreq'] as String,
      riskName: json['riskName'] as String,
      risk: (json['risk'] as List<dynamic>).map((e) => e.toString()).toList(),
      riskText: json['riskText'] as String,
      general: json['general'] as String,
      tool: (json['tool'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'grade': grade,
      'gradeVer': gradeVer,
      'gender': gender,
      'sex': sex,
      'ageRange': ageRange,
      'text': text,
      'servFreq': servFreq,
      'riskName': riskName,
      'risk': risk,
      'riskText': riskText,
      'general': general,
      'tool': tool,
    };
  }
}

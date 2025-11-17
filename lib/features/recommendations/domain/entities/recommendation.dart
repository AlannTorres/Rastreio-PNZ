class Recommendation {
  final int id;
  final String title;
  final String grade;
  final int gradeVer;
  final String gender;
  final String sex;
  final List<int> ageRange;
  final String text;
  final String servFreq;
  final String riskName;
  final List<String> risk;
  final String riskText;
  final String general;
  final List<String> tool;

  Recommendation({
    required this.id,
    required this.title,
    required this.grade,
    required this.gradeVer,
    required this.gender,
    required this.sex,
    required this.ageRange,
    required this.text,
    required this.servFreq,
    required this.riskName,
    required this.risk,
    required this.riskText,
    required this.general,
    required this.tool,
  });
}

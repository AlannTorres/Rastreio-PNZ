import 'package:flutter/material.dart';
import '../../../../core/services/json_service.dart';
import '../../../recommendations/data/models/category_model.dart';
import '../widgets/recommendation_card.dart'; 
import 'recommendation_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Future<List<Map<String, dynamic>>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _loadFilteredRecommendations();
  }

  /// Carrega todas as recomendações e filtra por esta categoria
  Future<List<Map<String, dynamic>>> _loadFilteredRecommendations() async {
    final allRecommendations = await JsonService.loadRecommendations();

    List<Map<String, dynamic>> filtered = [];

    for (var rec in allRecommendations) {
      final String topicId = rec['general'] as String? ?? '';
      if (topicId.isNotEmpty) {
        final topic = await JsonService.loadTopicById(topicId);
        if (topic != null) {
          if (topic.categories.contains(widget.category.id)) {
            filtered.add(rec);
          }
        }
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recommendationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma recomendação encontrada para esta categoria.'));
          }

          final recommendations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              final ageRange = rec['ageRange'] as List<dynamic>?;
              final ageRangeText = ageRange != null && ageRange.length == 2
                  ? '${ageRange[0]}-${ageRange[1]} anos'
                  : 'N/A';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: RecommendationCard(
                  title: rec['title'] ?? 'Sem título',
                  subtitle: _extractSubtitle(rec),
                  grade: rec['grade'] ?? 'I',
                  ageRange: ageRangeText,
                  gender: rec['gender'] ?? 'N/A',
                  description: _cleanHtmlText(rec['text']),
                  isFavorite: rec['isFavorite'] as bool? ?? false,
                  onFavoriteTap: () {
                    setState(() {
                      rec['isFavorite'] = !(rec['isFavorite'] as bool? ?? false);
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationDetailPage(
                          recommendation: rec,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _extractSubtitle(Map<String, dynamic> rec) {
    final title = rec['title'] as String? ?? '';
    if (title.contains(':')) {
      return title.split(':').last.trim();
    }
    return title;
  }

  String _cleanHtmlText(String? htmlText) {
    if (htmlText == null) return '';
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&ndash;', '-')
        .trim();
  }
}
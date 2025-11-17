import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/recommendations/data/models/topic_model.dart';
import '../../features/recommendations/data/models/tool_model.dart';
import '../../features/recommendations/data/models/category_model.dart';

class JsonService {
  static Map<String, dynamic>? _fullData;

  static Future<Map<String, dynamic>> _loadFullData() async {
    if (_fullData != null) {
      return _fullData!;
    }
    
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/recommendations.json',
      );

      _fullData = json.decode(jsonString) as Map<String, dynamic>;
      return _fullData!;
    } catch (e) {
      print('Erro fatal ao carregar o JSON completo: $e');
      throw Exception('Não foi possível carregar recommendations.json. Verifique o caminho e o arquivo.');
    }
  }

  /// ========================================
  /// CARREGAR RECOMENDAÇÕES (Para a Home)
  static Future<List<Map<String, dynamic>>> loadRecommendations() async {
    try {
      final jsonData = await _loadFullData();
      final List<dynamic> recommendations =
          jsonData['specificRecommendations'] ?? [];
      return recommendations
          .map((rec) => rec as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erro ao carregar recomendações: $e');
      return [];
    }
  }

  /// ========================================
  /// CARREGAR TÓPICO POR ID
  static Future<TopicModel?> loadTopicById(String topicId) async {
    if (topicId.isEmpty) return null;
    try {
      final jsonData = await _loadFullData();
      final Map<String, dynamic> topicsMap = jsonData['generalRecommendations'] ?? {};
      if (topicsMap.containsKey(topicId)) {
        final topicData = topicsMap[topicId] as Map<String, dynamic>;
        return TopicModel.fromJson(topicData);
      }
      return null;
    } catch (e) {
      print('Erro ao carregar tópico $topicId: $e');
      return null;
    }
  }

  /// ========================================
  /// CARREGAR FERRAMENTAS POR LISTA DE IDs
  static Future<List<ToolModel>> loadToolsByIds(List<dynamic> toolIds) async {
    // ... (código existente) ...
    if (toolIds.isEmpty) return [];
    try {
      final jsonData = await _loadFullData();
      final Map<String, dynamic> toolsMap = jsonData['tools'] ?? {};
      List<ToolModel> tools = [];
      final List<String> stringIds = toolIds.map((id) => id.toString()).toList();

      for (String id in stringIds) {
        if (toolsMap.containsKey(id)) {
          final toolData = toolsMap[id] as Map<String, dynamic>;
          tools.add(ToolModel.fromJson(toolData));
        }
      }
      return tools;
    } catch (e) {
      print('Erro ao carregar ferramentas: $e');
      return [];
    }
  }

  /// ========================================
  /// CARREGAR LISTA DE CATEGORIAS
  static Future<List<CategoryModel>> loadCategories() async {
    try {
      final jsonData = await _loadFullData();
      final Map<String, dynamic> categoriesMap = jsonData['categories'] ?? {};
      
      List<CategoryModel> categories = [];

      categoriesMap.forEach((key, value) {
        categories.add(CategoryModel.fromJson(key, value as Map<String, dynamic>));
      });

      categories.sort((a, b) => a.name.compareTo(b.name));
      
      return categories;
    } catch (e) {
      print('Erro ao carregar categorias: $e');
      return [];
    }
  }

  /// ========================================
  /// NOVO: CARREGAR METADADOS DO JSON
  static Future<Map<String, String>> loadMetadata() async {
    try {
      final jsonData = await _loadFullData();
      return {
        'note': jsonData['note'] ?? '',
        'lastUpdated': jsonData['lastUpdated'] ?? '',
        'lastUpdatedText': jsonData['lastUpdatedText'] ?? '',
      };
    } catch (e) {
      print('Erro ao carregar metadados: $e');
      return {
        'note': '',
        'lastUpdated': '',
        'lastUpdatedText': 'Erro ao carregar',
      };
    }
  }
}
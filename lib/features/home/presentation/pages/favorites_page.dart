import 'package:flutter/material.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/json_service.dart';
import '../widgets/recommendation_card.dart';
import 'recommendation_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Guarda todas as recomendações para filtrar
  List<Map<String, dynamic>> _allRecommendations = [];
  // Guarda os IDs dos favoritos
  Set<int> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Carrega os dados em paralelo
    final results = await Future.wait([
      JsonService.loadRecommendations(),
      FavoriteService.loadFavorites(),
    ]);

    setState(() {
      _allRecommendations = results[0] as List<Map<String, dynamic>>;
      _favoriteIds = results[1] as Set<int>;
      _isLoading = false;
    });
  }

  // Função para alternar o favorito e ATUALIZAR A UI
  Future<void> _toggleFavorite(int id) async {
    bool isFav = _favoriteIds.contains(id);
    if (isFav) {
      await FavoriteService.removeFavorite(id);
    } else {
      await FavoriteService.addFavorite(id);
    }
    // Recarrega os favoritos do serviço para atualizar o estado
    _favoriteIds = await FavoriteService.loadFavorites();
    setState(() {}); // Atualiza a tela
  }

  // Filtra as recomendações para mostrar apenas favoritos
  List<Map<String, dynamic>> get _filteredRecommendations {
    return _allRecommendations.where((rec) {
      return _favoriteIds.contains(rec['id']);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Map<String, dynamic>> favorites = _filteredRecommendations;

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhum favorito salvo',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Clique no coração nos cards para salvar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final rec = favorites[index];
        final ageRange = rec['ageRange'] as List<dynamic>?;
        final ageRangeText = ageRange != null && ageRange.length == 2
            ? '${ageRange[0]}-${ageRange[1]} anos'
            : 'N/A';
        final isFavorite = _favoriteIds.contains(rec['id']);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: RecommendationCard(
            title: rec['title'] ?? 'Sem título',
            subtitle: _extractSubtitle(rec),
            grade: rec['grade'] ?? 'I',
            ageRange: ageRangeText,
            gender: rec['gender'] ?? 'N/A',
            description: _cleanHtmlText(rec['text']),
            isFavorite: isFavorite,
            onFavoriteTap: () {
              _toggleFavorite(rec['id']);
            },
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendationDetailPage(
                    recommendation: rec,
                  ),
                ),
              );

              _loadData();
            },
          ),
        );
      },
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
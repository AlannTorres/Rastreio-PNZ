import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _favoritesKey = 'favorite_recommendations';
  static const _disclaimerKey = 'has_seen_disclaimer';

  // Carrega a lista de IDs de favoritos
  static Future<Set<int>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(_favoritesKey) ?? [];
    return idStrings.map((id) => int.parse(id)).toSet();
  }

  // Salva a lista completa de IDs
  static Future<void> _saveFavorites(Set<int> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = favoriteIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, idStrings);
  }

  // Adiciona um ID aos favoritos
  static Future<void> addFavorite(int id) async {
    final favorites = await loadFavorites();
    favorites.add(id);
    await _saveFavorites(favorites);
  }

  // Remove um ID dos favoritos
  static Future<void> removeFavorite(int id) async {
    final favorites = await loadFavorites();
    favorites.remove(id);
    await _saveFavorites(favorites);
  }

  // Verifica se um ID é favorito (usado para alternar)
  static Future<bool> isFavorite(int id) async {
    final favorites = await loadFavorites();
    return favorites.contains(id);
  }

  // NOVO: Limpa todos os favoritos
  static Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  /// ========================================
  /// AVISO (Disclaimer)
  static Future<bool> hasSeenDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_disclaimerKey) ?? false;
  }

  static Future<void> setDisclaimerSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disclaimerKey, true);
  }
}


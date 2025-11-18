import 'package:flutter/material.dart';
import '../../../../app.dart'; 
import '../../../../core/services/favorite_service.dart'; 
import '../../../../core/services/json_service.dart';
import '../../../../core/services/theme_service.dart';
import '../widgets/recommendation_card.dart';
import 'recommendation_detail_page.dart';
import 'categories_list_page.dart';
import 'favorites_page.dart'; 
import 'settings_page.dart'; 
import 'sub_pages/terms_page.dart';

class HomePage extends StatefulWidget {
  final ThemeService themeService;
  
  const HomePage({super.key, required this.themeService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeService get _themeService => widget.themeService;
  
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // (Filtros) 
  int? _selectedAge;
  int? _selectedWeight;
  int? _selectedHeight;
  String? _selectedPregnant;
  String? _selectedSmoker;
  String? _selectedSexuallyActive;
  String? _selectedGender;
  String? _selectedGrade;

  List<Map<String, dynamic>> _allRecommendations = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  Set<int> _favoriteIds = {};

  final Map<String, bool> _expandedGrades = {
    'A': true,
    'B': true,
    'C': false,
    'D': false,
    'I': false,
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDisclaimer();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        JsonService.loadRecommendations(),
        FavoriteService.loadFavorites(),
      ]);
      
      setState(() {
        _allRecommendations = results[0] as List<Map<String, dynamic>>;
        _favoriteIds = results[1] as Set<int>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int id) async {
    bool isFav = _favoriteIds.contains(id);
    
    if (isFav) {
      await FavoriteService.removeFavorite(id);
      _favoriteIds.remove(id);
    } else {
      await FavoriteService.addFavorite(id);
      _favoriteIds.add(id);
    }
    
    setState(() {}); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRecommendations {
        return _allRecommendations.where((rec) {
      final searchText = _searchController.text.toLowerCase();
      if (searchText.isNotEmpty) {
        final title = (rec['title'] as String? ?? '').toLowerCase();
        final text = (rec['text'] as String? ?? '').toLowerCase();
        if (!title.contains(searchText) && !text.contains(searchText)) {
          return false;
        }
      }

      if (_selectedAge != null) {
        final ageRange = rec['ageRange'] as List<dynamic>?;
        if (ageRange != null && ageRange.length == 2) {
          final minAge = ageRange[0] as int;
          final maxAge = ageRange[1] as int;
          if (_selectedAge! < minAge || _selectedAge! > maxAge) {
            return false;
          }
        }
      }

      if (_selectedGender != null && _selectedGender != 'Todos') {
        final gender = (rec['gender'] as String? ?? '').toLowerCase();
        final sex = (rec['sex'] as String? ?? '').toLowerCase();
        
        if (_selectedGender == 'Homens') {
          if (!gender.contains('men') && !sex.contains('male') && 
              !gender.contains('homens') && !sex.contains('homens')) {
            return false;
          }
        } else if (_selectedGender == 'Mulheres') {
          if (!gender.contains('women') && !sex.contains('female') && 
              !gender.contains('mulheres') && !sex.contains('mulheres')) {
            return false;
          }
        }
      }

      if (_selectedGrade != null) {
        if (rec['grade'] != _selectedGrade) {
          return false;
        }
      }

      if (_selectedPregnant == 'Sim') {
        final title = (rec['title'] as String? ?? '').toLowerCase();
        final text = (rec['text'] as String? ?? '').toLowerCase();
        
        if (!title.contains('pregnant') && !title.contains('pregnancy') &&
            !title.contains('gestante') && !title.contains('grávida') &&
            !text.contains('pregnant') && !text.contains('pregnancy') &&
            !text.contains('gestante') && !text.contains('grávida')) {
          return false;
        }
      }

      if (_selectedSmoker == 'Sim') {
        final title = (rec['title'] as String? ?? '').toLowerCase();
        final text = (rec['text'] as String? ?? '').toLowerCase();
        final riskText = (rec['riskText'] as String? ?? '').toLowerCase();
        
        if (!title.contains('smok') && !title.contains('tobacco') &&
            !title.contains('fumante') && !title.contains('tabaco') &&
            !text.contains('smok') && !text.contains('tobacco') &&
            !text.contains('fumante') && !text.contains('tabaco') &&
            !riskText.contains('smok') && !riskText.contains('tobacco') &&
            !riskText.contains('fumante') && !riskText.contains('tabaco')) {
          return false;
        }
      }

      if (_selectedSexuallyActive == 'Sim') {
        final title = (rec['title'] as String? ?? '').toLowerCase();
        final text = (rec['text'] as String? ?? '').toLowerCase();
        final riskText = (rec['riskText'] as String? ?? '').toLowerCase();
        
        if (!title.contains('sexual') && !title.contains('sexually active') &&
            !title.contains('sexualmente ativo') && !title.contains('dst') &&
            !text.contains('sexual') && !text.contains('sexually active') &&
            !text.contains('sexualmente ativo') && !text.contains('dst') &&
            !riskText.contains('sexual') && !riskText.contains('sexually active') &&
            !riskText.contains('sexualmente ativo') && !riskText.contains('dst')) {
          return false;
        }
      }

      if (_selectedWeight != null && _selectedHeight != null) {
        final heightInMeters = _selectedHeight! / 100.0;
        final imc = _selectedWeight! / (heightInMeters * heightInMeters);
        
        final title = (rec['title'] as String? ?? '').toLowerCase();
        final text = (rec['text'] as String? ?? '').toLowerCase();
        final riskText = (rec['riskText'] as String? ?? '').toLowerCase();
        
        if (imc >= 25.0) {
          if (title.contains('obesity') || title.contains('overweight') ||
              title.contains('obesidade') || title.contains('sobrepeso') ||
              text.contains('obesity') || text.contains('overweight') ||
              text.contains('obesidade') || text.contains('sobrepeso') ||
              riskText.contains('obesity') || riskText.contains('overweight') ||
              riskText.contains('obesidade') || riskText.contains('sobrepeso')) {
          }
        }
      }

      return true;
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedRecommendations {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'A': [],
      'B': [],
      'C': [],
      'D': [],
      'I': [],
    };

    for (var rec in _filteredRecommendations) {
      final grade = rec['grade'] as String? ?? 'I';
      if (grouped.containsKey(grade)) {
        grouped[grade]!.add(rec);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtros',
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Rastreio PNZ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        scrolledUnderElevation: Theme.of(context).appBarTheme.scrolledUnderElevation,
        actions: [
          IconButton(
            icon: Icon(
              _themeService.isDarkMode 
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: _themeService.isDarkMode 
                ? 'Modo Claro' 
                : 'Modo Escuro',
            onPressed: () {
              _themeService.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(themeService: _themeService),
                ),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtros',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFiltersSection(),
              ],
            ),
          ),
        ),
      ),

      body: _buildRecommendationsList(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesListPage()),
            );
          } else if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
            _favoriteIds = await FavoriteService.loadFavorites();
            setState(() {});
          }
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.filter_list),
        label: const Text('Filtros'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFiltersSection() {
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pesquisar',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Digite para buscar...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            filled: true,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        Text(
          'Dados Pessoais',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 16),

        _buildFilterField(
          label: 'Idade (Anos)',
          hint: 'Ex: 30',
          onChanged: (value) {
            setState(() {
              _selectedAge = int.tryParse(value);
            });
          },
        ),
        const SizedBox(height: 16),

        _buildFilterField(
          label: 'Peso (Kg)',
          hint: 'Ex: 70',
          onChanged: (value) {
            setState(() {
              _selectedWeight = int.tryParse(value);
            });
          },
        ),
        const SizedBox(height: 16),

        _buildFilterField(
          label: 'Altura (Cm)',
          hint: 'Ex: 170',
          onChanged: (value) {
            setState(() {
              _selectedHeight = int.tryParse(value);
            });
          },
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        Text(
          'Características',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 16),

        _buildFilterDropdown(
          label: 'Sexo (Gênero)',
          value: _selectedGender,
          items: ['Todos', 'Homens', 'Mulheres'],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildFilterDropdown(
          label: 'Grávida?',
          value: _selectedPregnant,
          items: ['Todos', 'Não', 'Sim'], 
          onChanged: (value) {
            setState(() {
              _selectedPregnant = value == 'Todos' ? null : value;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildFilterDropdown(
          label: 'Fumante?',
          value: _selectedSmoker,
          items: ['Todos', 'Não', 'Sim'],
          onChanged: (value) {
            setState(() {
              _selectedSmoker = value == 'Todos' ? null : value;
            });
          },
        ),
        const SizedBox(height: 16),

        _buildFilterDropdown(
          label: 'Sexualmente Ativo?',
          value: _selectedSexuallyActive,
          items: ['Todos', 'Não', 'Sim'],
          onChanged: (value) {
            setState(() {
              _selectedSexuallyActive = value == 'Todos' ? null : value;
            });
          },
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        Text(
          'Grau da Recomendação',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 16),

        _buildFilterDropdown(
          label: 'Grau',
          value: _selectedGrade,
          items: ['Todos', 'A', 'B', 'C', 'D', 'I'],
          onChanged: (value) {
            setState(() {
              _selectedGrade = value == 'Todos' ? null : value;
            });
          },
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_filteredRecommendations.length} recomendações encontradas',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.search),
            label: const Text(
              'Buscar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedAge = null;
                _selectedWeight = null;
                _selectedHeight = null;
                _selectedGender = null;
                _selectedPregnant = null;
                _selectedSmoker = null;
                _selectedSexuallyActive = null; // Limpar novo filtro
                _selectedGrade = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtros limpos'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Limpar Filtros'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterField({
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(items[0]), // Mostra "Todos" como hint
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar dados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadInitialData,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final grouped = _groupedRecommendations;

    if (grouped.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Nenhuma recomendação encontrada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tente ajustar os filtros de busca',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...grouped.entries.map((entry) {
          final grade = entry.key;
          final recommendations = entry.value;
          final isExpanded = _expandedGrades[grade] ?? false;

          return _buildGradeGroup(
            grade: grade,
            recommendations: recommendations,
            isExpanded: isExpanded,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGradeGroup({
    required String grade,
    required List<Map<String, dynamic>> recommendations,
    required bool isExpanded,
  }) {
    final gradeColors = Theme.of(context).extension<GradeColors>()!;
    final theme = Theme.of(context);

    final Color strongGradeColor = _getGradeStrongColor(gradeColors, grade);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedGrades[grade] = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: strongGradeColor,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      grade,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: strongGradeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Text(
                      _getGradeTitle(grade),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${recommendations.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: recommendations.map((rec) {
                  final ageRange = rec['ageRange'] as List<dynamic>?;
                  final ageRangeText = ageRange != null && ageRange.length == 2
                      ? '${ageRange[0]}-${ageRange[1]} anos'
                      : 'N/A';
                  
                  final int recId = rec['id'] as int;
                  final bool isFavorite = _favoriteIds.contains(recId);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: RecommendationCard(
                      title: rec['title'] ?? 'Sem título',
                      subtitle: _extractSubtitle(rec),
                      grade: rec['grade'] ?? 'I',
                      ageRange: ageRangeText,
                      gender: rec['gender'] ?? 'N/A',
                      description: _cleanHtmlText(rec['text'] ?? ''),
                      isFavorite: isFavorite,
                      onFavoriteTap: () {
                        _toggleFavorite(recId);
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
                        _favoriteIds = await FavoriteService.loadFavorites();
                        setState(() {});
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// ========================================
  /// MÉTODOS AUXILIARES
  Color _getGradeStrongColor(GradeColors colors, String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return colors.gradeA;
      case 'B': return colors.gradeB;
      case 'C': return colors.gradeC;
      case 'D': return colors.gradeD;
      case 'I': return colors.gradeI;
      default: return colors.gradeI;
    }
  }

  String _getGradeTitle(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return 'Fortemente Recomendado';
      case 'B':
        return 'Recomendado';
      case 'C':
        return 'Sem Recomendação Específica';
      case 'D':
        return 'Não Recomendado';
      case 'I':
        return 'Evidência Insuficiente';
      default:
        return 'Desconhecido';
    }
  }

  String _extractSubtitle(Map<String, dynamic> rec) {
    final title = rec['title'] as String? ?? '';
    if (title.contains(':')) {
      return title.split(':').last.trim();
    }
    return title;
  }

  /// ========================================
  /// MÉTODOS DO AVISO INICIAL

  Future<void> _checkAndShowDisclaimer() async {
    bool seen = await FavoriteService.hasSeenDisclaimer();
    
    if (!seen && context.mounted) {
      _showDisclaimerDialog();
    }
  }

  void _showDisclaimerDialog() {
    bool doNotShowAgain = false; 

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Aviso Importante'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Este site apresenta traduções e adaptações de recomendações da U.S. Preventive Services Task Force (USPSTF). O conteúdo original está disponível em https://www.uspreventiveservicestaskforce.org. As adaptações foram realizadas para refletir normas e diretrizes brasileiras. A USPSTF, a AHRQ e o U.S. Department of Health and Human Services não endossam nem se responsabilizam por este conteúdo adaptado.',
                    style: TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pop(dialogContext); 
                      Navigator.push( 
                        context,
                        MaterialPageRoute(builder: (context) => const TermsPage()),
                      );
                    },
                    child: Text(
                      'Ler os Termos de Uso',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: doNotShowAgain,
                        onChanged: (bool? value) {
                          setDialogState(() { 
                            doNotShowAgain = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('Não mostrar novamente'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (doNotShowAgain) {
                      await FavoriteService.setDisclaimerSeen();
                    }
                    Navigator.pop(dialogContext); 
                  },
                  child: const Text('OK, Entendi'),
                )
              ],
            );
          },
        );
      },
    );
  }

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&ndash;', '-')
        .trim();
  }
}
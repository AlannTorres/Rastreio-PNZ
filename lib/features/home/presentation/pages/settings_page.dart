import 'package:flutter/material.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/favorite_service.dart';
import 'sub_pages/about_page.dart';
import 'sub_pages/policy_page.dart';
import 'sub_pages/terms_page.dart';

class SettingsPage extends StatefulWidget {
  final ThemeService themeService;

  const SettingsPage({super.key, required this.themeService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _currentThemeMode;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.themeService.themeMode;
    widget.themeService.addListener(_updateTheme);
  }

  @override
  void dispose() {
    widget.themeService.removeListener(_updateTheme);
    super.dispose();
  }

  void _updateTheme() {
    setState(() {
      _currentThemeMode = widget.themeService.themeMode;
    });
  }
  
  String _getThemeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Modo Claro';
      case ThemeMode.dark:
        return 'Modo Escuro';
      case ThemeMode.system:
        return 'Padrão do Sistema';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle('Aparência'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Modo de Tema'),
            subtitle: Text(_getThemeModeString(_currentThemeMode)),
            onTap: _showThemeDialog,
          ),
          const Divider(),
          _buildSectionTitle('Gerenciamento de Dados'),
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color: Colors.red.shade700),
            title: Text(
              'Limpar Favoritos',
              style: TextStyle(color: Colors.red.shade700),
            ),
            subtitle: const Text('Remove todas as recomendações salvas'),
            onTap: _showClearFavoritesDialog,
          ),
          const Divider(),
          _buildSectionTitle('Sobre'),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Termos de Uso'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Política de Privacidade'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        ],
      ),
    );
  }

  // Constrói um título de seção padronizado
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  // Mostra o diálogo de seleção de tema
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolher Modo de Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Modo Claro'),
                value: ThemeMode.light,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  widget.themeService.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Modo Escuro'),
                value: ThemeMode.dark,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  widget.themeService.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Padrão do Sistema'),
                value: ThemeMode.system,
                groupValue: _currentThemeMode,
                onChanged: (value) {
                  widget.themeService.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Mostra o diálogo de confirmação para limpar favoritos
  void _showClearFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Limpar Favoritos'),
          content: const Text('Você tem certeza que deseja remover todos os seus favoritos? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              onPressed: () async {
                await FavoriteService.clearAllFavorites();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Favoritos limpos com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );
  }
}
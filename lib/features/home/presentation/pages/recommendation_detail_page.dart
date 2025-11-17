import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../core/services/json_service.dart';
import '../../../recommendations/data/models/tool_model.dart';
import '../../../recommendations/data/models/topic_model.dart';

class RecommendationDetailPage extends StatefulWidget {
  final Map<String, dynamic> recommendation;

  const RecommendationDetailPage({
    super.key,
    required this.recommendation,
  });

  @override
  State<RecommendationDetailPage> createState() =>
      _RecommendationDetailPageState();
}

class _RecommendationDetailPageState extends State<RecommendationDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TopicModel? _topicData;
  List<ToolModel> _tools = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String topicId = widget.recommendation['general'] as String? ?? '';
      
      final List<dynamic> toolIds = widget.recommendation['tool'] as List<dynamic>? ?? [];

      final results = await Future.wait([
        JsonService.loadTopicById(topicId),
        JsonService.loadToolsByIds(toolIds),
      ]);

      setState(() {
        _topicData = results[0] as TopicModel?;
        _tools = results[1] as List<ToolModel>;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar detalhes: $e';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recommendation['title'],
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border), 
            tooltip: 'Favoritar',
            onPressed: () {
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Geral'),
            Tab(text: 'Avaliação'),
            Tab(text: 'Prática'),
            Tab(text: 'Outros'),
            Tab(text: 'Guias'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGeneralTab(),
                    _buildHtmlContentTab(
                      title: 'Avaliação da Recomendação',
                      htmlContent: _topicData?.rationale,
                      prependWidget: _buildInfoCard(
                        title: 'Grau ${widget.recommendation['grade']}',
                        contentWidget: Text(
                          _getGradeDescription(widget.recommendation['grade']),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    _buildHtmlContentTab(
                      title: 'Considerações Práticas',
                      htmlContent: _topicData?.clinical,
                    ),
                    _buildHtmlContentTab(
                      title: 'Outras Informações',
                      htmlContent: '${_topicData?.other}\n\n${_topicData?.discussion}',
                    ),
                    _buildGuidesTab(),
                  ],
                ),
    );
  }

  /// ========================================
  /// ABA GERAL (ATUALIZADA)
  /// ========================================
  Widget _buildGeneralTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informações Gerais'),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: widget.recommendation['title'],
            contentWidget: HtmlWidget(
              widget.recommendation['text'] ?? 'Sem descrição.',
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Grau', widget.recommendation['grade'] ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow('Faixa Etária', _formatAgeRange(widget.recommendation['ageRange'])),
          const SizedBox(height: 12),
          _buildInfoRow('Gênero', widget.recommendation['gender'] ?? 'N/A'),
        ],
      ),
    );
  }

  /// ========================================
  /// ABA DE CONTEÚDO HTML (ATUALIZADA)
  /// ========================================
  Widget _buildHtmlContentTab({
    required String title,
    String? htmlContent,
    Widget? prependWidget,
  }) {
    final String content = htmlContent ?? '';
    final theme = Theme.of(context);

    if (content.isEmpty && prependWidget == null) {
      return _buildEmptyState('Nenhuma informação disponível.');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 16),
          if (prependWidget != null) ...[
            prependWidget,
            const SizedBox(height: 16),
          ],
          if (content.isNotEmpty)
            _buildInfoCard(
              title: 'Detalhes',
              contentWidget: HtmlWidget(
                content,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
                onTapUrl: (url) async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return true;
                  }
                  return false;
                },
              ),
            )
          else
             _buildInfoCard(
              title: 'Detalhes',
              contentWidget: Text(
                'Nenhuma informação disponível.',
                 style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ========================================
  /// ABA GUIAS
  /// ========================================
  Widget _buildGuidesTab() {
    if (_tools.isEmpty) {
      return _buildEmptyState('Nenhum guia relacionado encontrado.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _tools.length,
      itemBuilder: (context, index) {
        final tool = _tools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(tool.title),
            subtitle: Text(
              tool.url,
              style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () async {
              final uri = Uri.parse(tool.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Não foi possível abrir: ${tool.url}')),
                );
              }
            },
          ),
        );
      },
    );
  }

  /// ========================================
  /// WIDGETS AUXILIARES (ATUALIZADOS)
  /// ========================================
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget contentWidget}) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(height: 24),
            contentWidget, 
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: theme.colorScheme.onSurface
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGradeDescription(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return 'Este serviço é fortemente recomendado. Há alta certeza de que o benefício líquido é substancial.';
      case 'B':
        return 'Este serviço é recomendado. Há alta certeza de que o benefício líquido é moderado ou há certeza moderada de que o benefício líquido é moderado a substancial.';
      case 'C':
        return 'A recomendação é contra o fornecimento rotineiro deste serviço. Pode haver considerações que apoiem o fornecimento do serviço em um paciente individual.';
      case 'D':
        return 'Este serviço não é recomendado. Há certeza moderada ou alta de que o serviço não tem benefício líquido ou que os danos superam os benefícios.';
      case 'I':
        return 'Conclui-se que a evidência atual é insuficiente para avaliar o equilíbrio entre benefícios e danos do serviço.';
      default:
        return 'Informação não disponível.';
    }
  }

  String _formatAgeRange(dynamic ageRange) {
    if (ageRange is List<dynamic> && ageRange.length == 2) {
      return '${ageRange[0]} - ${ageRange[1]} anos';
    }
    return ageRange?.toString() ?? 'N/A';
  }
}
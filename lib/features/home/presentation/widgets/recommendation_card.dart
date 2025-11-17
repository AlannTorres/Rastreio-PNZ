import 'package:flutter/material.dart';
import '../../../../app.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String grade;
  final String ageRange;
  final String gender;
  final String description;
  final VoidCallback onTap;
  
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.grade,
    required this.ageRange,
    required this.gender,
    required this.description,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradeColors = Theme.of(context).extension<GradeColors>()!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(gradeColors, grade), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(gradeColors, grade), 
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(gradeColors, grade),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      _getGradeIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface, 
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.7), 
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red.shade400 : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  tooltip: isFavorite ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos',
                  onPressed: onFavoriteTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ========================================
  /// MÉTODOS AUXILIARES - CORES E ÍCONES
  /// ========================================
  Color _getBackgroundColor(GradeColors colors, String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return colors.gradeASoft;
      case 'B': return colors.gradeBSoft;
      case 'C': return colors.gradeCSoft;
      case 'D': return colors.gradeDSoft;
      case 'I': return colors.gradeISoft;
      default: return colors.gradeISoft;
    }
  }

  Color _getBorderColor(GradeColors colors, String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return colors.gradeA.withOpacity(0.3);
      case 'B': return colors.gradeB.withOpacity(0.3);
      case 'C': return colors.gradeC.withOpacity(0.3);
      case 'D': return colors.gradeD.withOpacity(0.3);
      case 'I': return colors.gradeI.withOpacity(0.3);
      default: return colors.gradeI.withOpacity(0.3);
    }
  }

  Color _getIconBackgroundColor(GradeColors colors, String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return colors.gradeA;
      case 'B': return colors.gradeB;
      case 'C': return colors.gradeC;
      case 'D': return colors.gradeD;
      case 'I': return colors.gradeI;
      default: return colors.gradeI;
    }
  }

  IconData _getGradeIcon() {
    switch (grade.toUpperCase()) {
      case 'A':
        return Icons.check_circle;
      case 'B':
        return Icons.thumb_up;
      case 'C':
        return Icons.info;
      case 'D':
        return Icons.cancel;
      case 'I':
        return Icons.help;
      default:
        return Icons.circle;
    }
  }
}
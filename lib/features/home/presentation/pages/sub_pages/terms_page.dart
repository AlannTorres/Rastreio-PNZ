import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termos de Uso',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bem-vindo ao Rastreio PNZ.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
             const Text(
              'Este aplicativo é uma ferramenta de referência educacional e informativa. As informações aqui contidas são destinadas a profissionais de saúde e não substituem o julgamento clínico independente.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildSection(
              '1. Isenção de Responsabilidade Médica',
              'As recomendações são baseadas nos dados da USPSTF e não constituem aconselhamento médico direto. A decisão final sobre o cuidado do paciente deve ser tomada pelo profissional de saúde em consulta com o paciente.',
            ),
            _buildSection(
              '2. Precisão da Informação',
              'Embora façamos esforços para manter as informações atualizadas, não garantimos a exatidão, integridade ou atualidade de qualquer informação. Os dados podem ser atualizados e alterados sem aviso prévio.',
            ),
            _buildSection(
              '3. Uso do Aplicativo',
              'Você concorda em usar este aplicativo apenas para fins legais e informativos. Você não deve usar este aplicativo para diagnosticar ou tratar uma condição de saúde.',
            ),
            _buildSection(
              '4. Limitação de Responsabilidade',
              'Em nenhuma circunstância os desenvolvedores do Rastreio PNZ serão responsáveis por quaisquer danos diretos, indiretos, incidentais ou consequenciais resultantes do uso ou da incapacidade de usar este aplicativo.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17, 
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
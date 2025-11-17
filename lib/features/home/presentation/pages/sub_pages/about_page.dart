import 'package:flutter/material.dart';
import '../../../../../core/services/json_service.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.medical_information_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Rastreio PNZ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'Desenvolvido por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Este site foi desenvolvido por internos do curso de Medicina da Universidade Federal do Vale do São Francisco (UNIVASF) como parte do projeto de intervenção do rodízio de Medicina de Família e Comunidade.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildCreditRow('Internos:', 'Marília Leal e Jivago Dias'),
            const SizedBox(height: 8),
            _buildCreditRow('Orientadores:', 'Aymée Torres e Victor Gallindo'),
            const SizedBox(height: 8),
            _buildCreditRow('Programador:', 'Alan Torres'),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'Fonte dos Dados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'USPSTF Recommendation Data (JSON)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
             const Text(
              'Este aplicativo fornece acesso rápido às recomendações de rastreio da Força-Tarefa de Serviços Preventivos dos EUA (USPSTF).',
               style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, String>>(
              future: JsonService.loadMetadata(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Última atualização dos dados: ${snapshot.data?['lastUpdatedText'] ?? 'N/D'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  );
                }
                return const Text('Carregando data...', style: TextStyle(fontSize: 14, color: Colors.grey));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditRow(String title, String names) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            names,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidade',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Esta política descreve como o Rastreio PNZ lida com suas informações.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

             _buildSection(
              '1. Coleta de Dados',
              'Este aplicativo NÃO coleta, transmite ou armazena qualquer informação de identificação pessoal (PII).',
            ),
             _buildSection(
              '2. Dados Locais',
              'Para a funcionalidade de "Favoritos", o aplicativo salva uma lista de IDs de recomendações localmente no seu dispositivo usando o pacote `shared_preferences`. Estes dados nunca saem do seu dispositivo e são usados apenas para lembrar suas escolhas dentro do app.',
            ),
             _buildSection(
              '3. Dados do Aplicativo',
              'Todos os dados de recomendações são carregados a partir de um arquivo JSON estático (`recommendations.json`) incluído no pacote do aplicativo. Nenhuma conexão de rede é feita para buscar ou enviar dados de recomendações.',
            ),
             _buildSection(
              '4. Limpeza de Dados',
              'Você pode limpar seus dados de "Favoritos" a qualquer momento através da opção "Limpar Favoritos" na tela de Configurações. Desinstalar o aplicativo também removerá todos os dados armazenados localmente.',
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
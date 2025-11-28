import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class StatsScreen extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  const StatsScreen({
    super.key,
    required this.moodEntries,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text(
          'Статистика',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ваша статистика',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'За последние 7 дней',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 32),

              // График (заглушка)
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Динамика настроения',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Неделя',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF667EEA),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: moodEntries.isEmpty
                            ? _buildEmptyChart()
                            : _buildChartPlaceholder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Статистика в цифрах
              Text(
                'Общая статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              moodEntries.isEmpty ? _buildEmptyStats() : _buildStatsGrid(stats),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bar_chart_rounded,
          size: 48,
          color: Color(0xFF667EEA),
        ),
        const SizedBox(height: 12),
        Text(
          'График будет доступен\nпосле добавления записей',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildChartPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: 48,
          color: Color(0xFF667EEA),
        ),
        const SizedBox(height: 12),
        Text(
          '${moodEntries.length} записей\nдля анализа',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStats() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.insights_rounded,
            size: 48,
            color: Color(0xFFA0AEC0),
          ),
          const SizedBox(height: 16),
          Text(
            'Добавьте записи\nдля просмотра статистики',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, int> stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                emoji: '😊',
                value: '${stats['good'] ?? 0}',
                label: 'Хороших дней',
                color: Color(0xFF8BC34A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                emoji: '😐',
                value: '${stats['neutral'] ?? 0}',
                label: 'Нейтральных',
                color: Color(0xFFFFC107),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                emoji: '😍',
                value: '${stats['excellent'] ?? 0}',
                label: 'Отличных дней',
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                emoji: '😔',
                value: '${stats['bad'] ?? 0}',
                label: 'Сложных дней',
                color: Color(0xFFF44336),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Среднее значение
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getAverageMoodEmoji(stats),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Среднее настроение',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                    Text(
                      _getAverageMoodText(stats),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, int> _calculateStats() {
    final stats = <String, int>{
      'excellent': 0,
      'good': 0,
      'neutral': 0,
      'bad': 0,
      'terrible': 0,
    };

    for (final entry in moodEntries) {
      stats[entry.mood] = (stats[entry.mood] ?? 0) + 1;
    }

    return stats;
  }

  String _getAverageMoodEmoji(Map<String, int> stats) {
    final total = moodEntries.length;
    if (total == 0) return '😐';

    final excellent = stats['excellent'] ?? 0;
    final good = stats['good'] ?? 0;
    final neutral = stats['neutral'] ?? 0;
    final bad = stats['bad'] ?? 0;
    final terrible = stats['terrible'] ?? 0;

    if (excellent > good && excellent > neutral && excellent > bad && excellent > terrible) {
      return '😍';
    } else if (good > excellent && good > neutral && good > bad && good > terrible) {
      return '😊';
    } else if (bad > excellent && bad > good && bad > neutral && bad > terrible) {
      return '😔';
    } else if (terrible > excellent && terrible > good && terrible > neutral && terrible > bad) {
      return '😫';
    } else {
      return '😐';
    }
  }

  String _getAverageMoodText(Map<String, int> stats) {
    final total = moodEntries.length;
    if (total == 0) return 'Недостаточно данных';

    final emoji = _getAverageMoodEmoji(stats);
    switch (emoji) {
      case '😍': return 'Отлично';
      case '😊': return 'Хорошо';
      case '😐': return 'Нейтрально';
      case '😔': return 'Плохо';
      case '😫': return 'Ужасно';
      default: return 'Нейтрально';
    }
  }
}

class StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}
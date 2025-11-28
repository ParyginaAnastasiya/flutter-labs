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
    final dailyStats = _calculateDailyStats();
    final weeklyStats = _calculateWeeklyStats();
    final stats = _calculateStats(dailyStats);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
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
              const Text(
                'Ваша статистика',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Всего записей: ${moodEntries.length}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 32),

              // График настроений за неделю
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Динамика настроения за неделю',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: dailyStats.isEmpty
                          ? _buildEmptyChart()
                          : _buildWeeklyChart(weeklyStats),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Статистика в цифрах
              const Text(
                'Общая статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              dailyStats.isEmpty ? _buildEmptyStats() : _buildStatsGrid(stats, dailyStats.length),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bar_chart_rounded,
          size: 48,
          color: Color(0xFF667EEA),
        ),
        SizedBox(height: 12),
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

  Widget _buildWeeklyChart(Map<DateTime, String> weeklyStats) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final now = DateTime.now();

    return Column(
      children: [
        // Подписи дней недели
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return Text(
                days[index],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // График (столбцы)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final day = now.subtract(Duration(days: 6 - index));
              final dayKey = DateTime(day.year, day.month, day.day);
              final mood = weeklyStats[dayKey];
              final height = _getMoodHeight(mood);

              return Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 20,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMoodEmoji(mood),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  String _getMoodEmoji(String? mood) {
    switch (mood) {
      case 'excellent': return '😍';
      case 'good': return '😊';
      case 'neutral': return '😐';
      case 'bad': return '😔';
      case 'terrible': return '😫';
      default: return '─';
    }
  }

  double _getMoodHeight(String? mood) {
    switch (mood) {
      case 'excellent': return 80.0;
      case 'good': return 60.0;
      case 'neutral': return 40.0;
      case 'bad': return 25.0;
      case 'terrible': return 15.0;
      default: return 5.0;
    }
  }

  Widget _buildEmptyStats() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.insights_rounded,
            size: 48,
            color: Color(0xFFA0AEC0),
          ),
          SizedBox(height: 16),
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

  Widget _buildStatsGrid(Map<String, int> stats, int totalDays) {
    return Column(
      children: [
        // Первый ряд: отличные и хорошие дни
        Row(
          children: [
            Expanded(
              child: StatCard(
                emoji: '😍',
                value: '${stats['excellent'] ?? 0}',
                label: 'Супер дней',
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                emoji: '😊',
                value: '${stats['good'] ?? 0}',
                label: 'Хороших дней',
                color: const Color(0xFF8BC34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Второй ряд: нейтральные и плохие дни
        Row(
          children: [
            Expanded(
              child: StatCard(
                emoji: '😐',
                value: '${stats['neutral'] ?? 0}',
                label: 'Нейтральных дней',
                color: const Color(0xFFFFC107),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                emoji: '😔',
                value: '${stats['bad'] ?? 0}',
                label: 'Плохих дней',
                color: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Третий ряд: ужасные дни и общее количество
        Row(
          children: [
            Expanded(
              child: StatCard(
                emoji: '😫',
                value: '${stats['terrible'] ?? 0}',
                label: 'Ужасных дней',
                color: const Color(0xFFF44336),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
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
                    const Text('📊', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      '$totalDays',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Всего дней',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Среднее значение
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                    const Text(
                      'Среднее настроение',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getAverageMoodText(stats),
                      style: const TextStyle(
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

  // Получаем уникальные дни с настроениями (берем последнюю запись за день)
  Map<DateTime, String> _calculateDailyStats() {
    final dailyStats = <DateTime, String>{};

    // Сортируем записи по дате (от новых к старым)
    final sortedEntries = List<MoodEntry>.from(moodEntries)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final entry in sortedEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      // Берем только последнюю запись для каждого дня
      if (!dailyStats.containsKey(date)) {
        dailyStats[date] = entry.mood;
      }
    }

    return dailyStats;
  }

  Map<String, int> _calculateStats(Map<DateTime, String> dailyStats) {
    final stats = <String, int>{
      'excellent': 0,
      'good': 0,
      'neutral': 0,
      'bad': 0,
      'terrible': 0,
    };

    for (final mood in dailyStats.values) {
      stats[mood] = (stats[mood] ?? 0) + 1;
    }

    return stats;
  }

  Map<DateTime, String> _calculateWeeklyStats() {
    final stats = <DateTime, String>{};
    final now = DateTime.now();
    final dailyStats = _calculateDailyStats();

    // Инициализируем последние 7 дней
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      stats[dayKey] = 'none';
    }

    // Заполняем реальными данными
    for (final entry in dailyStats.entries) {
      if (stats.containsKey(entry.key)) {
        stats[entry.key] = entry.value;
      }
    }

    return stats;
  }

  String _getAverageMoodEmoji(Map<String, int> stats) {
    final total = stats.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return '😐';

    final excellent = stats['excellent'] ?? 0;
    final good = stats['good'] ?? 0;
    final neutral = stats['neutral'] ?? 0;
    final bad = stats['bad'] ?? 0;
    final terrible = stats['terrible'] ?? 0;

    // Находим наиболее часто встречающееся настроение
    final maxCount = [excellent, good, neutral, bad, terrible].reduce((a, b) => a > b ? a : b);

    if (maxCount == excellent) return '😍';
    if (maxCount == good) return '😊';
    if (maxCount == bad) return '😔';
    if (maxCount == terrible) return '😫';
    return '😐';
  }

  String _getAverageMoodText(Map<String, int> stats) {
    final total = stats.values.fold(0, (sum, count) => sum + count);
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
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
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Временные данные для демонстрации
    final List<Map<String, dynamic>> entries = [
      {'date': 'Сегодня', 'mood': 'Нейтрально', 'note': 'Был тяжелый день на работе', 'color': Color(0xFFFFC107)},
      {'date': 'Вчера', 'mood': 'Хорошо', 'note': 'Встретился с друзьями', 'color': Color(0xFF8BC34A)},
      {'date': '25 мая', 'mood': 'Супер', 'note': 'Отпуск!', 'color': Color(0xFF4CAF50)},
      {'date': '24 мая', 'mood': 'Плохо', 'note': 'Проблемы со здоровьем', 'color': Color(0xFFFF9800)},
      {'date': '23 мая', 'mood': 'Ужасно', 'note': 'Очень сложный день', 'color': Color(0xFFF44336)},
      {'date': '22 мая', 'mood': 'Хорошо', 'note': 'Закончил важный проект', 'color': Color(0xFF8BC34A)},
    ];

    // Функция для получения эмодзи по типу настроения
    String _getMoodEmoji(String mood) {
      switch (mood) {
        case 'Супер': return '😍';
        case 'Хорошо': return '😊';
        case 'Нейтрально': return '😐';
        case 'Плохо': return '😔';
        case 'Ужасно': return '😫';
        default: return '😐';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text(
          'История настроений',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final mood = entry['mood'] as String;
          final date = entry['date'] as String;
          final note = entry['note'] as String;
          final color = entry['color'] as Color;
          final emoji = _getMoodEmoji(mood);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(50)),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              title: Text(
                mood,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      note,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
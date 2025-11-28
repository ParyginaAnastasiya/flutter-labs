import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<Map<String, dynamic>> moods = [
      {'emoji': '😍', 'label': 'Супер', 'value': 'excellent', 'color': Color(0xFF4CAF50)},
      {'emoji': '😊', 'label': 'Хорошо', 'value': 'good', 'color': Color(0xFF8BC34A)},
      {'emoji': '😐', 'label': 'Нейтрально', 'value': 'neutral', 'color': Color(0xFFFFC107)},
      {'emoji': '😔', 'label': 'Плохо', 'value': 'bad', 'color': Color(0xFFFF9800)},
      {'emoji': '😫', 'label': 'Ужасно', 'value': 'terrible', 'color': Color(0xFFF44336)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Как вы себя чувствуете?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moods.map((mood) {
            final isSelected = selectedMood == mood['value'];
            final moodColor = mood['color'] as Color;
            final moodEmoji = mood['emoji'] as String;
            final moodLabel = mood['label'] as String;
            final moodValue = mood['value'] as String;

            return GestureDetector(
              onTap: () => onMoodSelected(moodValue),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? moodColor : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? moodColor : const Color(0xFFE2E8F0),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      moodEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      moodLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
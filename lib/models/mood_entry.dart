class MoodEntry {
  final int? id;
  final DateTime date;
  final String mood;
  final String? note;
  final int rating;

  MoodEntry({
    this.id,
    required this.date,
    required this.mood,
    this.note,
    required this.rating,
  });

  // Метод для создания объекта из значений
  factory MoodEntry.fromValues({
    required String mood,
    String? note,
    required int rating,
  }) {
    return MoodEntry(
      date: DateTime.now(),
      mood: mood,
      note: note,
      rating: rating,
    );
  }

  // Преобразование в Map для SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'mood': mood,
      'note': note,
      'rating': rating,
    };
  }

  // Получить эмодзи для настроения
  String get emoji {
    switch (mood) {
      case 'excellent': return '😍';
      case 'good': return '😊';
      case 'neutral': return '😐';
      case 'bad': return '😔';
      case 'terrible': return '😫';
      default: return '😐';
    }
  }

  // Получить текстовое представление настроения
  String get moodText {
    switch (mood) {
      case 'excellent': return 'Супер';
      case 'good': return 'Хорошо';
      case 'neutral': return 'Нейтрально';
      case 'bad': return 'Плохо';
      case 'terrible': return 'Ужасно';
      default: return 'Нейтрально';
    }
  }

  // Получить цвет для настроения
  int get moodColor {
    switch (mood) {
      case 'excellent': return 0xFF4CAF50;
      case 'good': return 0xFF8BC34A;
      case 'neutral': return 0xFFFFC107;
      case 'bad': return 0xFFFF9800;
      case 'terrible': return 0xFFF44336;
      default: return 0xFFFFC107;
    }
  }
}
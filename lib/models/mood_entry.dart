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
}
import 'package:flutter/foundation.dart';
import '../data/local/database_helper.dart';
import '../data/remote/quote_service.dart';
import '../models/mood_entry.dart';

class MoodRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final QuoteService _quoteService = QuoteService();

  // Работа с записями настроения
  Future<int> addMoodEntry(MoodEntry entry) async {
    try {
      return await _databaseHelper.insertEntry(entry);
    } catch (e) {
      debugPrint('Ошибка при сохранении записи: $e');
      rethrow;
    }
  }

  Future<List<MoodEntry>> getAllEntries() async {
    try {
      return await _databaseHelper.getEntries();
    } catch (e) {
      debugPrint('Ошибка при загрузке записей: $e');
      return [];
    }
  }

  Future<List<MoodEntry>> getLastWeekEntries() async {
    try {
      return await _databaseHelper.getLastWeekEntries();
    } catch (e) {
      debugPrint('Ошибка при загрузке записей за неделю: $e');
      return [];
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await _databaseHelper.deleteEntry(id);
    } catch (e) {
      debugPrint('Ошибка при удалении записи: $e');
      rethrow;
    }
  }

  // Работа с цитатами
  Future<Quote> getRandomQuote() async {
    try {
      return await _quoteService.getRandomQuote();
    } catch (e) {
      debugPrint('Ошибка при загрузке цитаты: $e');
      return const Quote(
        text: 'Счастье - это не что-то готовое. Оно происходит из ваших собственных действий.',
        author: 'Далай-лама',
      );
    }
  }
}
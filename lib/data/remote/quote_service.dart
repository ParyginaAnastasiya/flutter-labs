import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static final QuoteService _instance = QuoteService._internal();
  factory QuoteService() => _instance;
  QuoteService._internal();

  Future<Quote> getRandomQuote() async {
    try {
      debugPrint('Загрузка цитаты с Forismatic API...');

      final response = await http.get(
        Uri.parse('https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=ru'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MoodTracker/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final quote = Quote(
          text: json['quoteText']?.toString().trim() ?? '',
          author: json['quoteAuthor']?.toString().trim() ?? 'Неизвестный автор',
        );

        if (quote.text.isNotEmpty) {
          debugPrint('Цитата успешно загружена: ${quote.text}');
          return quote;
        }
      }

      // Если API не сработало, используем локальные цитаты
      return _getFallbackQuote();
    } catch (e) {
      debugPrint('Ошибка при загрузке цитаты: $e');
      return _getFallbackQuote();
    }
  }

  Quote _getFallbackQuote() {
    // Локальный список русских цитат
    final quotes = [
      const Quote(
        text: 'Счастье - это не что-то готовое. Оно происходит из ваших собственных действий.',
        author: 'Далай-лама',
      ),
      const Quote(
        text: 'Лучший способ начать делать - перестать говорить и начать делать.',
        author: 'Уолт Дисней',
      ),
      const Quote(
        text: 'Единственный способ делать великие дела - любить то, что вы делаете.',
        author: 'Стив Джобс',
      ),
      const Quote(
        text: 'Успех - это способность идти от неудачи к неудаче, не теряя энтузиазма.',
        author: 'Уинстон Черчилль',
      ),
      const Quote(
        text: 'Будущее принадлежит тем, кто верит в красоту своей мечты.',
        author: 'Элеонора Рузвельт',
      ),
    ];

    final randomIndex = DateTime.now().millisecondsSinceEpoch % quotes.length;
    return quotes[randomIndex];
  }
}

class Quote {
  final String text;
  final String author;

  const Quote({
    required this.text,
    required this.author,
  });
}
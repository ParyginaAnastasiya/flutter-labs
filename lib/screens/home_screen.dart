import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../repositories/mood_repository.dart';
import '../data/remote/quote_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onAddEntry;
  final List<MoodEntry> moodEntries;
  final MoodRepository moodRepository;

  const HomeScreen({
    super.key,
    required this.onAddEntry,
    required this.moodEntries,
    required this.moodRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Quote? _currentQuote;
  bool _isLoadingQuote = false;

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    setState(() {
      _isLoadingQuote = true;
    });

    try {
      final quote = await widget.moodRepository.getRandomQuote();
      setState(() {
        _currentQuote = quote;
      });
    } catch (e) {
      debugPrint('Ошибка в UI при загрузке цитаты: $e');
      setState(() {
        _currentQuote = const Quote(
          text: 'Счастье - это не что-то готовое. Оно происходит из ваших собственных действий.',
          author: 'Далай-лама',
        );
      });
    } finally {
      setState(() {
        _isLoadingQuote = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayEntry = _getTodayEntry();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              const Text(
                'Трекер настроения',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Сегодня, ${_getFormattedDate()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 40),

              // Карточка текущего настроения
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33667EEA),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Ваше настроение сегодня',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(color: Colors.white.withAlpha(76)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            todayEntry?.emoji ?? '😐',
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            todayEntry?.moodText ?? 'Не указано',
                            style: const TextStyle(
                              fontSize: 20,
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
              const SizedBox(height: 32),

              // Основная кнопка
              Container(
                width: double.infinity,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33667EEA),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onAddEntry,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Добавить запись',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Карточка с цитатой
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFF667EEA), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Цитата дня',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        if (!_isLoadingQuote)
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF667EEA)),
                            onPressed: _loadRandomQuote,
                            tooltip: 'Обновить цитату',
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _isLoadingQuote
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentQuote?.text ?? 'Загрузка...',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A5568),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '- ${_currentQuote?.author ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MoodEntry? _getTodayEntry() {
    final now = DateTime.now();
    for (final entry in widget.moodEntries) {
      if (entry.date.year == now.year &&
          entry.date.month == now.month &&
          entry.date.day == now.day) {
        return entry;
      }
    }
    return null;
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
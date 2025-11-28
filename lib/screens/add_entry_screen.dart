import 'package:flutter/material.dart';
import '../widgets/mood_selector.dart';
import '../models/mood_entry.dart';

class AddEntryScreen extends StatefulWidget {
  final Function(MoodEntry) onSaveEntry;

  const AddEntryScreen({
    super.key,
    required this.onSaveEntry,
  });

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  String _selectedMood = 'neutral';
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'Новая запись',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF667EEA)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Выбор настроения
              MoodSelector(
                selectedMood: _selectedMood,
                onMoodSelected: (mood) {
                  setState(() {
                    _selectedMood = mood;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Поле для комментария
              const Text(
                'Комментарий',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Необязательно',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                child: TextField(
                  controller: _noteController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Опишите, что повлияло на ваше настроение...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                  ),
                ),
              ),
              const Spacer(),

              // Кнопка сохранения
              Container(
                width: double.infinity,
                height: 56,
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
                    onTap: _saveEntry,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: const Center(
                      child: Text(
                        'Сохранить запись',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEntry() {
    if (_selectedMood.isEmpty) return;

    final entry = MoodEntry.fromValues(
      mood: _selectedMood,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      rating: _getRatingFromMood(_selectedMood),
    );

    widget.onSaveEntry(entry);
  }

  int _getRatingFromMood(String mood) {
    switch (mood) {
      case 'excellent': return 5;
      case 'good': return 4;
      case 'neutral': return 3;
      case 'bad': return 2;
      case 'terrible': return 1;
      default: return 3;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
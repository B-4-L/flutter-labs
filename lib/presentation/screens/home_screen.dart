import 'package:flutter/material.dart';
import '../../domain/use_cases/habit_use_cases.dart';
import '../../domain/use_cases/quote_use_cases.dart';
import '../../domain/models/habit.dart';
import '../widgets/habit_card.dart';
import 'about_screen.dart';
import 'quotes_screen.dart';

class HomeScreen extends StatefulWidget {
  final HabitUseCases habitUseCases;
  final QuoteUseCases quoteUseCases;

  const HomeScreen({
    super.key,
    required this.habitUseCases,
    required this.quoteUseCases,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    try {
      final habits = await widget.habitUseCases.getHabits();
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) _showSnackBar('Ошибка загрузки привычек');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addHabit(String title, String description) async {
    try {
      await widget.habitUseCases.addHabit(title, description);
      await _loadHabits();
      if (mounted) _showSnackBar('Привычка "$title" добавлена!');
    } catch (e) {
      if (mounted) _showSnackBar('Ошибка добавления привычки');
    }
  }

  Future<void> _toggleHabit(Habit habit) async {
    try {
      await widget.habitUseCases.toggleHabit(habit);
      await _loadHabits();
    } catch (e) {
      if (mounted) _showSnackBar('Ошибка обновления привычки');
    }
  }

  Future<void> _deleteHabit(String habitId) async {
    try {
      await widget.habitUseCases.deleteHabit(habitId);
      await _loadHabits();
      if (mounted) _showSnackBar('Привычка удалена');
    } catch (e) {
      if (mounted) _showSnackBar('Ошибка удаления привычки');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showAddHabitDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Добавить привычку'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название привычки*',
                      hintText: 'Например: Пить воду',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 50,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      hintText: 'Например: 2 литра в день',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    maxLength: 100,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: titleController.text.isNotEmpty
                      ? () async {
                          await _addHabit(
                            titleController.text,
                            descController.text,
                          );
                          Navigator.pop(dialogContext);
                        }
                      : null,
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToQuotesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotesScreen(quoteUseCases: widget.quoteUseCases),
      ),
    );
  }

  void _navigateToAboutScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои привычки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _navigateToAboutScreen,
            tooltip: 'О приложении',
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _navigateToQuotesScreen,
            tooltip: 'Мотивационные цитаты',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHabits,
            tooltip: 'Обновить привычки',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Нет привычек', style: TextStyle(fontSize: 20, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Нажмите "+" чтобы добавить первую привычку',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _habits.length,
                  itemBuilder: (context, index) {
                    final habit = _habits[index];
                    return HabitCard(
                      habit: habit,
                      onToggle: () => _toggleHabit(habit),
                      onDelete: () => _deleteHabit(habit.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
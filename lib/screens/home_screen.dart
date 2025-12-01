import 'package:flutter/material.dart';
import 'quotes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Список привычек
  List<Map<String, dynamic>> habits = [
    {
      'id': 1,
      'title': 'Пить воду',
      'description': '2 литра в день',
      'streak': 7,
      'completed': true,
    },
    {
      'id': 2,
      'title': 'Утренняя зарядка',
      'description': '15 минут',
      'streak': 3,
      'completed': false,
    },
    {
      'id': 3,
      'title': 'Чтение',
      'description': '20 минут перед сном',
      'streak': 14,
      'completed': true,
    },
  ];

  // Для ввода новой привычки
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Добавление новой привычки
  void _addHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить привычку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название привычки',
                  hintText: 'Например: Пить воду',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Например: 2 литра в день',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _titleController.clear();
                _descController.clear();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    habits.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'title': _titleController.text,
                      'description': _descController.text.isNotEmpty
                          ? _descController.text
                          : 'Без описания',
                      'streak': 0,
                      'completed': false,
                    });
                  });
                  _titleController.clear();
                  _descController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  // Отметка выполнения привычки
  void _toggleHabit(int index) {
    setState(() {
      habits[index]['completed'] = !habits[index]['completed'];
      if (habits[index]['completed']) {
        habits[index]['streak'] += 1;
      }
    });
  }

  // Удаление привычки
  void _deleteHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить привычку?'),
          content: Text(
              'Вы уверены, что хотите удалить привычку "${habits[index]['title']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  habits.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои привычки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'Мотивация',
            onPressed: () {
              // Навигация через MaterialPageRoute
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuotesScreen(),
                  settings: const RouteSettings(name: '/quotes'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'О приложении',
            onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('О приложении'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Трекер привычек v1.0\n',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Данное мобильное приложение было разработано в рамках дисциплины "Разработка мобильных приложений".\n',
                        ),
                        const Text(
                          'Автор: Рожин Денис\n'
                          'Группа: РПС-41\n'
                          'Вологодский государственный университет\n',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Трекер привычек помогает формировать полезные привычки и отслеживать прогресс.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            },
          ),
        ],
      ),
      body: habits.isEmpty
          ? const Center(
              child: Text(
                'Добавьте первую привычку!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _toggleHabit(index),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: habit['completed']
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          habit['completed'] ? Icons.check : Icons.access_time,
                          color: habit['completed'] ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    title: Text(
                      habit['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: habit['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit['description']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text('${habit['streak']} дней подряд'),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteHabit(index),
                    ),
                    onTap: () => _toggleHabit(index),
                    onLongPress: () => _deleteHabit(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Привычки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Мотивация',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuotesScreen()),
            );
          }
        },
      ),
    );
  }
}
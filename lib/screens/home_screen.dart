import 'package:flutter/material.dart';
import 'quotes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои привычки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuotesScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.local_drink),
            title: Text('Пить воду'),
            subtitle: Text('2 литра в день • 7 дней подряд'),
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Утренняя зарядка'),
            subtitle: Text('15 минут • 3 дня подряд'),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Чтение'),
            subtitle: Text('20 минут • 14 дней подряд'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  // Список мотивирующих цитат
  final List<Map<String, String>> quotes = [
    {
      'text': 'Мы – это то, что мы постоянно делаем. Совершенство, значит, не действие, а привычка.',
      'author': 'Аристотель',
    },
    {
      'text': 'Маленькие ежедневные улучшения со временем приводят к потрясающим результатам.',
      'author': 'Робин Шарма',
    },
    {
      'text': 'Победители – это просто проигравшие, которые попробовали ещё один раз.',
      'author': 'Джордж Мур',
    },
    {
      'text': 'Будущее зависит от того, что вы делаете сегодня.',
      'author': 'Махатма Ганди',
    },
    {
      'text': 'Самый лучший способ взяться за что-то – перестать говорить и начать делать.',
      'author': 'Уолт Дисней',
    },
  ];

  int currentQuoteIndex = 0;

  // Следующая цитата
  void _nextQuote() {
    setState(() {
      currentQuoteIndex = (currentQuoteIndex + 1) % quotes.length;
    });
  }

  // Предыдущая цитата
  void _prevQuote() {
    setState(() {
      currentQuoteIndex = (currentQuoteIndex - 1 + quotes.length) % quotes.length;
    });
  }

  // Случайная цитата
  void _randomQuote() {
    setState(() {
      int newIndex;
      do {
        newIndex = DateTime.now().millisecond % quotes.length;
      } while (newIndex == currentQuoteIndex && quotes.length > 1);
      currentQuoteIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мотивация'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Иконка
            Icon(
              Icons.lightbulb,
              size: 80,
              color: Colors.deepPurple.shade300,
            ),
            const SizedBox(height: 30),
            
            // Цитата
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '«${quotes[currentQuoteIndex]['text']}»',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '— ${quotes[currentQuoteIndex]['author']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Цитата ${currentQuoteIndex + 1} из ${quotes.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Кнопки управления
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _prevQuote,
                  icon: const Icon(Icons.navigate_before),
                  label: const Text('Назад'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _randomQuote,
                  icon: const Icon(Icons.autorenew),
                  label: const Text('Случайная'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _nextQuote,
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Вперед'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Информация
            const Text(
              'Каждая маленькая привычка ведет к большим изменениям!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
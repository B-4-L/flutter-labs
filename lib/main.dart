import 'package:flutter/material.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/quote_repository.dart';
import 'domain/use_cases/habit_use_cases.dart';
import 'domain/use_cases/quote_use_cases.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализация зависимостей
    final habitRepository = HabitRepository();
    final habitUseCases = HabitUseCases(habitRepository);
    
    final quoteRepository = QuoteRepository();
    final quoteUseCases = QuoteUseCases(quoteRepository);
    
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(
        habitUseCases: habitUseCases,
        quoteUseCases: quoteUseCases,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
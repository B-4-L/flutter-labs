import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/habit.dart';
import 'dart:convert';

class HabitRepository {
  static const String _storageKey = 'habits';

  Future<List<Habit>> getAllHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList(_storageKey) ?? [];
      
      return habitsJson
          .map((json) => Habit.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load habits: $e');
    }
  }

  Future<void> saveHabits(List<Habit> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = habits
          .map((habit) => jsonEncode(habit.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, habitsJson);
    } catch (e) {
      throw Exception('Failed to save habits: $e');
    }
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getAllHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final habits = await getAllHabits();
    final index = habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      habits[index] = updatedHabit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final habits = await getAllHabits();
    habits.removeWhere((h) => h.id == habitId);
    await saveHabits(habits);
  }
}
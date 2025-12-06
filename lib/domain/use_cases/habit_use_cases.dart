import '../../data/repositories/habit_repository.dart';
import '../../domain/models/habit.dart';
import 'dart:math';

class HabitUseCases {
  final HabitRepository _repository;

  HabitUseCases(this._repository);

  Future<List<Habit>> getHabits() async {
    return await _repository.getAllHabits();
  }

  Future<void> addHabit(String title, String description) async {
    final habit = Habit(
      id: Random().nextInt(999999).toString(),
      title: title,
      description: description,
      streak: 0,
      completed: false,
      createdAt: DateTime.now(),
      lastCompletedAt: null,
    );
    await _repository.addHabit(habit);
  }

  Future<void> toggleHabit(Habit habit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (habit.lastCompletedAt != null) {
      final lastCompletedDay = DateTime(
        habit.lastCompletedAt!.year, 
        habit.lastCompletedAt!.month, 
        habit.lastCompletedAt!.day
      );
      
      if (lastCompletedDay.isAtSameMomentAs(today)) {
        final updatedHabit = habit.copyWith(
          completed: false,
          streak: habit.streak > 0 ? habit.streak - 1 : 0,
          lastCompletedAt: null,
        );
        await _repository.updateHabit(updatedHabit);
        return;
      }
      
      final daysDifference = today.difference(lastCompletedDay).inDays;
      if (daysDifference > 1) {
        final updatedHabit = habit.copyWith(
          completed: true,
          streak: 1,
          lastCompletedAt: now,
        );
        await _repository.updateHabit(updatedHabit);
        return;
      }
      
      if (daysDifference == 1) {
        final updatedHabit = habit.copyWith(
          completed: true,
          streak: habit.streak + 1,
          lastCompletedAt: now,
        );
        await _repository.updateHabit(updatedHabit);
        return;
      }
    }
    
    final updatedHabit = habit.copyWith(
      completed: true,
      streak: habit.streak + (habit.completed ? 0 : 1),
      lastCompletedAt: now,
    );
    await _repository.updateHabit(updatedHabit);
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
  }
}
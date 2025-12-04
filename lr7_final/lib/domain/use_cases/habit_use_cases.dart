import '../../data/repositories/habit_repository.dart';
import '../models/habit.dart';

class HabitUseCases {
  final HabitRepository _repository;

  HabitUseCases(this._repository);

  Future<List<Habit>> getHabits() => _repository.getAllHabits();

  Future<void> addHabit(String title, String description) async {
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description.isNotEmpty ? description : 'Без описания',
      streak: 0,
      completed: false,
      createdAt: DateTime.now(),
    );
    await _repository.addHabit(habit);
  }

  Future<void> toggleHabit(Habit habit) async {
    final updatedHabit = habit.copyWith(
      completed: !habit.completed,
      streak: !habit.completed ? habit.streak + 1 : habit.streak,
      lastCompletedAt: !habit.completed ? DateTime.now() : null,
    );
    await _repository.updateHabit(updatedHabit);
  }

  Future<void> deleteHabit(String habitId) => _repository.deleteHabit(habitId);
}
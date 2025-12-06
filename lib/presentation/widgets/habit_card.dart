import 'package:flutter/material.dart';
import '../../domain/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Никогда';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final habitDay = DateTime(date.year, date.month, date.day);
    
    if (habitDay.isAtSameMomentAs(today)) {
      return 'Сегодня';
    } else if (habitDay.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return 'Вчера';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: habit.completed ? Colors.green : Colors.grey.shade800,
                          decoration: habit.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (habit.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            habit.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    habit.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: habit.completed ? Colors.green : Colors.grey,
                  ),
                  onPressed: onToggle,
                  tooltip: habit.completed
                      ? 'Отметить как невыполненную'
                      : 'Отметить как выполненную',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${habit.streak} ${_getStreakWord(habit.streak)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      'Последнее: ${_formatDate(habit.lastCompletedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Создано: ${habit.createdAt.day}.${habit.createdAt.month}.${habit.createdAt.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: onDelete,
                  color: Colors.red.shade300,
                  tooltip: 'Удалить привычку',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStreakWord(int streak) {
    if (streak % 10 == 1 && streak % 100 != 11) return 'день';
    if (streak % 10 >= 2 && streak % 10 <= 4 && 
        (streak % 100 < 10 || streak % 100 >= 20)) return 'дня';
    return 'дней';
  }
}
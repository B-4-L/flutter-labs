import 'package:http/http.dart' as http;
import '../../domain/models/quote.dart';
import 'dart:convert';

class QuoteRepository {
  final String _apiUrl = 'https://api.quotable.io/random';
  
  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'HabitTrackerApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote(
          text: data['content'] ?? data['quote'] ?? '',
          author: data['author'] ?? 'Неизвестный автор',
        );
      } else if (response.statusCode == 429) {
        throw Exception('Слишком много запросов. Попробуйте позже.');
      } else {
        throw Exception('API вернул статус код ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Неверный формат ответа от сервера');
      } else if (e is http.ClientException) {
        throw Exception('Ошибка соединения: ${e.message}');
      }
      throw Exception('Не удалось загрузить цитату: $e');
    }
  }

  List<Quote> getLocalQuotes() {
    return [
      Quote(
        text: 'Мы – это то, что мы постоянно делаем. Совершенство, значит, не действие, а привычка.',
        author: 'Аристотель',
      ),
      Quote(
        text: 'Маленькие ежедневные улучшения со временем приводят к потрясающим результатам.',
        author: 'Робин Шарма',
      ),
      Quote(
        text: 'Победители – это просто проигравшие, которые попробовали ещё один раз.',
        author: 'Джордж Мур',
      ),
      Quote(
        text: 'Успех — это сумма небольших усилий, повторяющихся изо дня в день.',
        author: 'Роберт Кольер',
      ),
      Quote(
        text: 'Будущее зависит от того, что вы делаете сегодня.',
        author: 'Махатма Ганди',
      ),
      Quote(
        text: 'Лучший способ начать — это перестать говорить и начать делать.',
        author: 'Уолт Дисней',
      ),
      Quote(
        text: 'Ваши привычки определяют вашу жизнь.',
        author: 'Джим Рон',
      ),
      Quote(
        text: 'Дисциплина — это мост между целями и достижениями.',
        author: 'Джим Рон',
      ),
      Quote(
        text: 'Не ждите. Время никогда не будет подходящим.',
        author: 'Наполеон Хилл',
      ),
      Quote(
        text: 'Сила воли — это мышца, которую нужно тренировать ежедневно.',
        author: 'Неизвестный автор',
      ),
    ];
  }
}
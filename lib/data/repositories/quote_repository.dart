import 'package:http/http.dart' as http;
import '../../domain/models/quote.dart';
import 'dart:convert';

class QuoteRepository {
  final List<String> _apiUrls = [
    'https://api.quotable.io/quotes/random',
    'https://zenquotes.io/api/random',
  ];
  
  Future<Quote> getRandomQuote() async {
    for (final apiUrl in _apiUrls) {
      try {
        final response = await http.get(
          Uri.parse(apiUrl),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return _parseQuote(data, apiUrl);
        }
      } catch (e) {
        continue;
      }
    }
    
    throw Exception('API не отвечают');
  }

  Quote _parseQuote(Map<String, dynamic> data, String apiUrl) {
    if (apiUrl.contains('quotable')) {
      if (data is List && data.isNotEmpty) {
        return Quote(
          text: data[0]['content']?.toString() ?? '',
          author: data[0]['author']?.toString() ?? 'Unknown',
        );
      }
      return Quote(
        text: data['content']?.toString() ?? '',
        author: data['author']?.toString() ?? 'Unknown',
      );
    } else if (apiUrl.contains('zenquotes')) {
      if (data is List && data.isNotEmpty) {
        return Quote(
          text: data[0]['q']?.toString() ?? '',
          author: data[0]['a']?.toString() ?? 'Unknown',
        );
      }
    }
    
    return Quote(text: '', author: '');
  }

  List<Quote> getLocalQuotes() {
    return [
      Quote
      (
        text: 'Мы – это то, что мы постоянно делаем.',
        author: 'Аристотель'
        ),
      Quote
      (
        text: 'Маленькие улучшения приводят к результатам.', 
        author: 'Робин Шарма'
      ),
      Quote
      (
        text: 'Успех — это сумма небольших усилий.', 
        author: 'Роберт Кольер'
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
import 'package:http/http.dart' as http;
import '../../domain/models/quote.dart';
import 'dart:convert';

class QuoteRepository {
  final String _apiUrl = 'https://api.quotable.io/random';

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote.fromJson(data);
      } else {
        throw Exception('API returned status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }

  // Локальные цитаты для fallback
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
    ];
  }
}
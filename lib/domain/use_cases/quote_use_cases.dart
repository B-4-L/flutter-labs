import '../../data/repositories/quote_repository.dart';
import '../../domain/models/quote.dart';
import 'dart:math';

class QuoteUseCases {
  final QuoteRepository _repository;
  final Random _random = Random();
  List<Quote> _shownLocalQuotes = [];

  QuoteUseCases(this._repository);

  Future<Quote> getRandomQuote() async {
    try {
      return await _repository.getRandomQuote();
    } catch (e) {
      return _getRandomLocalQuote();
    }
  }

  Quote _getRandomLocalQuote() {
    final localQuotes = _repository.getLocalQuotes();
    if (localQuotes.isEmpty) {
      return Quote(text: 'Начните с малого.', author: 'Трекер привычек');
    }
    
    final randomIndex = _random.nextInt(localQuotes.length);
    return localQuotes[randomIndex];
  }

  List<Quote> getLocalQuotes() {
    return _repository.getLocalQuotes();
  }
}
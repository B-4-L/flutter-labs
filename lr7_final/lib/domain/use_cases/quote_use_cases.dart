import '../../data/repositories/quote_repository.dart';
import '../models/quote.dart';

class QuoteUseCases {
  final QuoteRepository _repository;

  QuoteUseCases(this._repository);

  Future<Quote> getRandomQuote() async {
    try {
      return await _repository.getRandomQuote();
    } catch (e) {
      // Fallback на локальные цитаты
      final localQuotes = _repository.getLocalQuotes();
      final index = DateTime.now().millisecond % localQuotes.length;
      return localQuotes[index];
    }
  }

  List<Quote> getLocalQuotes() => _repository.getLocalQuotes();
}
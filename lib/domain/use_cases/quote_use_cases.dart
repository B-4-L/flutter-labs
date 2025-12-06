import '../../data/repositories/quote_repository.dart';
import '../../domain/models/quote.dart';

class QuoteUseCases {
  final QuoteRepository _repository;

  QuoteUseCases(this._repository);

  Future<Quote> getRandomQuote() async {
    return await _repository.getRandomQuote();
  }

  List<Quote> getLocalQuotes() {
    return _repository.getLocalQuotes();
  }
}
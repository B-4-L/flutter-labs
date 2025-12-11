import 'package:flutter/material.dart';
import '../../domain/use_cases/quote_use_cases.dart';
import '../../domain/models/quote.dart';
import 'dart:math';

class QuotesScreen extends StatefulWidget {
  final QuoteUseCases quoteUseCases;

  const QuotesScreen({super.key, required this.quoteUseCases});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  Quote? _currentQuote;
  bool _isLoading = false;
  String _source = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadInternetQuote();
  }

  Future<void> _loadInternetQuote() async {
    setState(() {
      _isLoading = true;
      _source = '';
    });

    try {
      final quote = await widget.quoteUseCases.getRandomQuote();
      setState(() {
        _currentQuote = quote;
        _source = 'Из интернета';
      });
    } catch (e) {
      // Если API не работает, показываем случайную локальную
      _showRandomLocalQuote();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _loadLocalQuote() {
    _showRandomLocalQuote();
  }

  void _showRandomLocalQuote() {
    final localQuotes = widget.quoteUseCases.getLocalQuotes();
    if (localQuotes.isNotEmpty) {
      final randomIndex = _random.nextInt(localQuotes.length);
      setState(() {
        _currentQuote = localQuotes[randomIndex];
        _source = 'Локальная';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цитаты'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_currentQuote != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '«${_currentQuote!.text}»',
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '— ${_currentQuote!.author}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      if (_source.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _source,
                            style: TextStyle(
                              fontSize: 12,
                              color: _source == 'Из интернета' 
                                  ? Colors.blue 
                                  : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadInternetQuote,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Из интернета'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadLocalQuote,
                  icon: const Icon(Icons.phone_android),
                  label: const Text('Локальная'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../domain/use_cases/quote_use_cases.dart';
import '../../domain/models/quote.dart';

class QuotesScreen extends StatefulWidget {
  final QuoteUseCases quoteUseCases;

  const QuotesScreen({super.key, required this.quoteUseCases});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  Quote? _currentQuote;
  bool _isLoading = false;
  String _statusMessage = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Загружаем из интернета...';
      _errorMessage = '';
    });

    try {
      final quote = await widget.quoteUseCases.getRandomQuote();
      setState(() {
        _currentQuote = quote;
        _statusMessage = 'Цитата загружена из интернета';
      });
    } catch (e) {
      final localQuotes = widget.quoteUseCases.getLocalQuotes();
      setState(() {
        _currentQuote = localQuotes.isNotEmpty ? localQuotes[0] : null;
        _statusMessage = 'Используем локальную цитату';
        _errorMessage = 'Ошибка: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

void _showLocalQuote() {
  final localQuotes = widget.quoteUseCases.getLocalQuotes();
  if (localQuotes.isEmpty) return;
  
  int currentIndex = 0;
  if (_currentQuote != null) {
    final index = localQuotes.indexWhere(
      (quote) => quote.text == _currentQuote!.text
    );
    if (index != -1) {
      currentIndex = index;
    }
  }
  
  final nextIndex = (currentIndex + 1) % localQuotes.length;
  
  setState(() {
    _currentQuote = localQuotes[nextIndex];
    _statusMessage = 'Локальная цитата'; 
    _errorMessage = '';
  });
}

  @override
  Widget build(BuildContext context) {
    if (_currentQuote == null && !_isLoading) {
      final localQuotes = widget.quoteUseCases.getLocalQuotes();
      if (localQuotes.isNotEmpty) {
        _currentQuote = localQuotes[0];
        _statusMessage = 'Локальная цитата';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мотивационные цитаты'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 80,
              color: Colors.deepPurple.shade300,
            ),
            const SizedBox(height: 20),
            
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Загружаем цитату из интернета...'),
                ],
              )
            else if (_currentQuote != null)
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: Colors.deepPurple.shade200,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '«${_currentQuote!.text}»',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '— ${_currentQuote!.author}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            
              if (_statusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: _statusMessage.contains('интернета') 
                          ? Colors.green 
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadRandomQuote,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Новая из интернета'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _showLocalQuote,
                  icon: const Icon(Icons.phone_android),
                  label: const Text('Следующая локальная'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Всего локальных цитат: ${widget.quoteUseCases.getLocalQuotes().length}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 5),
            
            const Text(
              'API: api.quotable.io/random',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
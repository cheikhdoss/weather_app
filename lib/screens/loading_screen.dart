import 'dart:async';
import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import 'result_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  int _messageIndex = 0;
  late Timer _timer;
  late Timer _messageTimer;
  List<Weather> _weathers = [];
  final WeatherApiService _apiService = WeatherApiService();
  bool _hasError = false;
  String _errorMessage = '';

  final List<String> _messages = [
    'Nous téléchargeons les données...',
    'C''est presque fini...',
    'Plus que quelques secondes avant d''avoir le résultat...'
  ];

  @override
  void initState() {
    super.initState();
    _startProgress();
    _startMessageLoop();
  }

  void _startProgress() {
    _hasError = false;
    _errorMessage = '';
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
        }
      });
      if (_progress >= 1.0) {
        _timer.cancel();
        _messageTimer.cancel();
        try {
          await _fetchAllWeather();
          if (_hasError) {
            setState(() {
              _errorMessage = 'Erreur lors de la récupération des données météo. Vérifiez votre connexion et réessayez.';
            });
          } else if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  cities: senegalCities,
                  weathers: _weathers,
                  onRestart: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ),
            );
          }
        } catch (e) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Erreur lors de la récupération des données météo. Vérifiez votre connexion et réessayez.';
          });
        }
      }
    });
  }

  void _startMessageLoop() {
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  Future<void> _fetchAllWeather() async {
    _weathers = [];
    _hasError = false;
    for (final city in senegalCities) {
      try {
        final weather = await _apiService.fetchWeather(city);
        _weathers.add(weather);
      } catch (e) {
        _weathers.add(Weather(
          temperature: 0,
          description: 'Erreur',
          humidity: 0,
          windSpeed: 0,
        ));
        _hasError = true;
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _messageTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: _hasError
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
                    const SizedBox(height: 16),
                    Text(_errorMessage,
                        style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _progress = 0.0;
                          _hasError = false;
                          _errorMessage = '';
                        });
                        _startProgress();
                        _startMessageLoop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF2193b0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Retenter'),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: _progress),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, child) {
                              return CircularProgressIndicator(
                                value: value,
                                strokeWidth: 14,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2193b0)),
                                semanticsLabel: 'Progression',
                              );
                            },
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _progress < 1.0 ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: Icon(Icons.cloud_download_rounded, color: Colors.white, size: 54),
                        ),
                        if (_progress >= 1.0)
                          Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 54),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            '${(_progress * 100).toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(2,2))],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        _messages[_messageIndex],
                        key: ValueKey(_messages[_messageIndex]),
                        style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
} 
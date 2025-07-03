import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import 'result_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  double _progress = 0.0;
  int _messageIndex = 0;
  late Timer _progressTimer;
  late Timer _messageTimer;
  List<Weather> _weathers = [];
  final WeatherApiService _apiService = WeatherApiService();
  bool _hasError = false;
  String _errorMessage = '';

  late AnimationController _cloudController;
  late AnimationController _sunController;
  late AnimationController _weatherIconController;
  late Animation<double> _scaleAnimation;

  final List<String> _messages = [
    'Prédiction des conditions météorologiques...',
    'Analyse des vents et précipitations...',
    'Calcul des températures pour chaque ville...',
    'Préparation de votre rapport météo personnalisé...',
    'Plus que quelques instants...'
  ];

  final List<IconData> _messageIcons = [
    Icons.cloud_outlined,
    Icons.air,
    Icons.thermostat_outlined,
    Icons.article_outlined,
    Icons.timelapse,
  ];

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _sunController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _weatherIconController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _weatherIconController, curve: Curves.elasticOut),
    );
    _weatherIconController.forward();

    _startMessageLoop();
    _startProgress();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _weathers.clear();
      _hasError = false;

      for (final city in senegalCities) {
        try {
          final weather = await _apiService.fetchWeather(city);
          _weathers.add(weather);
        } catch (_) {
          _weathers.add(Weather(
            temperature: 0,
            description: 'Erreur',
            humidity: 0,
            windSpeed: 0,
          ));
          _hasError = true;
        }
      }

      while (_progress < 1.0) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      if (_hasError) {
        setState(() {
          _errorMessage = 'Impossible de récupérer les données météo. Vérifiez votre connexion internet et réessayez.';
        });
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, _) => ResultScreen(
              cities: senegalCities,
              weathers: _weathers,
              onRestart: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez.';
      });
    }
  }

  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) return timer.cancel();

      setState(() {
        double increment = 0.01;
        if (_progress > 0.3 && _progress < 0.7) {
          increment = 0.005 + (math.Random().nextDouble() * 0.008);
        } else if (_progress >= 0.7) {
          increment = 0.02;
        }
        _progress += increment;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _progressTimer.cancel();
        }
      });
    });
  }

  void _startMessageLoop() {
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
        _weatherIconController
          ..reset()
          ..forward();
      });
    });
  }

  @override
  void dispose() {
    _progressTimer.cancel();
    _messageTimer.cancel();
    _cloudController.dispose();
    _sunController.dispose();
    _weatherIconController.dispose();
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
        child: Stack(
          children: [
            _buildAnimatedBackground(),
            Center(
              child: _hasError ? _buildErrorView() : _buildLoadingView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          left: -100,
          child: AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(MediaQuery.of(context).size.width * _cloudController.value, 0),
                child: Opacity(
                  opacity: 0.5,
                  child: const Icon(Icons.cloud, size: 100, color: Colors.white),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          right: -80,
          child: AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-MediaQuery.of(context).size.width * (_cloudController.value * 0.7), 0),
                child: Opacity(
                  opacity: 0.3,
                  child: const Icon(Icons.cloud, size: 70, color: Colors.white),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.width * 0.1,
          child: AnimatedBuilder(
            animation: _sunController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_sunController.value * 0.1),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.yellow,
                        Colors.orange.withOpacity(0.7),
                        Colors.orange.withOpacity(0),
                      ],
                      stops: const [0.2, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInDown(
          child: Text(
            "Météo Sénégal",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 60),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _progress),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(
                      _progress < 1.0 ? Colors.white : Colors.greenAccent,
                    ),
                  );
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _progress < 1.0
                      ? ScaleTransition(
                          scale: _scaleAnimation,
                          child: Icon(
                            _messageIcons[_messageIndex],
                            key: ValueKey(_messageIndex),
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 50),
                ),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) => Text(
                    "${(value * 100).toInt()}%",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        FadeInUp(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _messages[_messageIndex],
              key: ValueKey(_messageIndex),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.white, size: 80),
          const SizedBox(height: 16),
          Text("Oops !", style: GoogleFonts.montserrat(fontSize: 28, color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _progress = 0.0;
                _messageIndex = 0;
                _hasError = false;
                _errorMessage = '';
              });
              _cloudController.repeat();
              _sunController.repeat(reverse: true);
              _weatherIconController.forward();
              _startMessageLoop();
              _startProgress();
              _loadData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2193b0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

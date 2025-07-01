import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'loading_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:untitled2/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late AnimationController _cloudAnimationController;
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.thermostat_outlined,
      'title': 'Température précise',
      'description': 'Obtenez des températures en temps réel pour les villes du Sénégal'
    },
    {
      'icon': Icons.water_drop_outlined,
      'title': 'Données d\'humidité',
      'description': 'Consultez les niveaux d\'humidité pour mieux planifier vos activités'
    },
    {
      'icon': Icons.air_outlined,
      'title': 'Information sur le vent',
      'description': 'Vitesse et direction du vent pour toutes les régions'
    },
  ];

  @override
  void initState() {
    super.initState();

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _cloudAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);

    // Auto-scroll for features carousel
    Future.delayed(const Duration(seconds: 3), () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _features.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _cloudAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenSize.height - padding.top - padding.bottom,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.02),

                      // App logo and title
                      _buildAppTitle(),

                      SizedBox(height: screenSize.height * 0.03),

                      // Main content
                      _buildWelcomeCard(),

                      SizedBox(height: screenSize.height * 0.03),

                      // Features carousel
                      _buildFeaturesCarousel(),

                      SizedBox(height: screenSize.height * 0.04),

                      // Action button
                      _buildActionButton(context),

                      SizedBox(height: screenSize.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? [
                Color(0xFF1E1E2D), // Dark theme background
                Color(0xFF2B2B40), // Dark theme surface
                Color(0xFF3699FF), // Dark theme primary
              ] : [
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
                Color(0xFF81D4FA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Animated gradient overlay
        AnimatedBuilder(
          animation: _backgroundAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark ? [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                  ] : [
                    Colors.blue[900]!.withOpacity(0.3),
                    Colors.blue[600]!.withOpacity(0.1),
                    Colors.blue[300]!.withOpacity(0.2),
                  ],
                  begin: Alignment(_backgroundAnimationController.value, -0.5),
                  end: Alignment(-_backgroundAnimationController.value, 0.5),
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),

        // Animated clouds
        ..._buildClouds(),

        // Sun/Moon
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark ? [
                  Colors.grey[400]!,
                  Colors.grey[500]!.withOpacity(0.6),
                  Colors.grey[600]!.withOpacity(0.0),
                ] : [
                  Colors.amber[300]!,
                  Colors.amber[400]!.withOpacity(0.6),
                  Colors.amber[500]!.withOpacity(0.0),
                ],
                stops: [0.2, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildClouds() {
    final clouds = <Widget>[];
    final random = math.Random(42); // Fixed seed for consistent generation

    for (var i = 0; i < 6; i++) {
      final size = 50.0 + random.nextDouble() * 100;
      final posX = random.nextDouble() * MediaQuery.of(context).size.width;
      final posY = random.nextDouble() * MediaQuery.of(context).size.height * 0.7;
      final opacity = 0.4 + random.nextDouble() * 0.3;
      final speed = 0.6 + random.nextDouble() * 0.4;

      clouds.add(
        Positioned(
          left: posX - size,
          top: posY,
          child: AnimatedBuilder(
            animation: _cloudAnimationController,
            builder: (context, child) {
              final dx = MediaQuery.of(context).size.width *
                  ((_cloudAnimationController.value * speed + (i / 10)) % 1.2);

              return Transform.translate(
                offset: Offset(dx, 0),
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.cloud,
                    size: size,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return clouds;
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Colors.amber[300],
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Météo Sénégal",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: const Offset(1, 1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Prévisions météorologiques nationales",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    final theme = Theme.of(context);
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark 
              ? Color(0xFF2B2B40) 
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              color: theme.colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Découvrez la météo du Sénégal',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Accédez aux données météorologiques en temps réel pour toutes les principales villes du pays.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: theme.brightness == Brightness.dark
                    ? Color(0xFFE5E5E5)
                    : Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCarousel() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 200),
          child: SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _features.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final feature = _features[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _currentPage == index ? 1.0 : 0.7,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: _currentPage == index ? 1.0 : 0.9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Color(0xFF2B2B40)
                              : Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                feature['icon'],
                                color: theme.colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                feature['title'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                feature['description'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: theme.brightness == Brightness.dark
                                      ? Color(0xFFE5E5E5)
                                      : Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Page indicator
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _features.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final theme = Theme.of(context);
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 400),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [Color(0xFF3699FF), Color(0xFF8950FC)]
                : [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const LoadingScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 700),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lancer l\'expérience',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
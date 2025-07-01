import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/city.dart';
import '../models/weather.dart';
import 'city_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final List<City> cities;
  final List<Weather> weathers;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.cities,
    required this.weathers,
    required this.onRestart,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [const Color(0xFF1E1E2D), const Color(0xFF2B2B40)]
              : [Colors.indigo[800]!, Colors.blue[400]!],
            stops: const [0.0, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 16),
              // Indication pour l'utilisateur
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? theme.cardColor.withOpacity(0.1)
                      : Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.blue[700]! : Colors.blue[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark ? Colors.blue[400] : Colors.blue[600],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Touchez le nom d\'une ville pour voir plus de détails',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark ? Colors.blue[100] : Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Table des données météo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Card(
                    elevation: 8,
                    color: isDark ? const Color(0xFF2B2B40) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: isDark
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.blue[50]!.withOpacity(0.3),
                                    ),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            'Ville',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.blue[300] : const Color(0xFF2193b0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Temp.',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.blue[300] : const Color(0xFF2193b0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Hum.',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.blue[300] : const Color(0xFF2193b0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...List.generate(widget.cities.length, (index) {
                                    final city = widget.cities[index];
                                    final weather = widget.weathers[index];
                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color: isDark
                                          ? (index % 2 == 0 
                                              ? Colors.black.withOpacity(0.1)
                                              : Colors.transparent)
                                          : (index % 2 == 0
                                              ? Colors.grey[50]!.withOpacity(0.3)
                                              : Colors.white),
                                      ),
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CityDetailScreen(
                                                      city: city,
                                                      weather: weather,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: isDark
                                                    ? Colors.blue.withOpacity(0.1)
                                                    : Colors.blue[50],
                                                  border: Border.all(
                                                    color: isDark
                                                      ? Colors.blue[700]!
                                                      : Colors.blue[200]!,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        city.name,
                                                        style: TextStyle(
                                                          color: isDark
                                                            ? Colors.blue[300]
                                                            : Colors.blue[700],
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 12,
                                                      color: isDark
                                                        ? Colors.blue[300]
                                                        : Colors.blue[700],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: isDark
                                                    ? Colors.black.withOpacity(0.2)
                                                    : Colors.grey[50],
                                                ),
                                                child: Text(
                                                  '${weather.temperature.toStringAsFixed(1)}°',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark ? Colors.blue[100] : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: isDark
                                                    ? Colors.black.withOpacity(0.2)
                                                    : Colors.grey[50],
                                                ),
                                                child: Text(
                                                  '${weather.humidity}%',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark ? Colors.blue[100] : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: widget.onRestart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? Colors.blue[600] : theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text(
                                'Recommencer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Text(
                'Résultats météo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _getWeatherIcon(String description) {
    IconData icon;
    switch (description.toLowerCase()) {
      case 'clear':
        icon = Icons.wb_sunny;
        break;
      case 'clouds':
        icon = Icons.cloud;
        break;
      case 'rain':
        icon = Icons.umbrella;
        break;
      case 'snow':
        icon = Icons.ac_unit;
        break;
      case 'erreur':
        icon = Icons.error_outline;
        break;
      default:
        icon = Icons.wb_cloudy;
    }
    return Icon(
      icon,
      color: Colors.blue[600],
      size: 24,
    );
  }
}
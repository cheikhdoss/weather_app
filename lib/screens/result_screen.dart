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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo[800]!, Colors.blue[400]!],
            stops: const [0.0, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 8),
              // Indication pour l'utilisateur
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Touchez le nom d\'une ville pour voir plus de détails',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: Colors.blue[100]!, width: 1),
                      ),
                      color: Colors.white.withOpacity(0.95),
                      shadowColor: Colors.blue[200]!.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                                (states) => Colors.blue[50]!.withOpacity(0.3),
                          ),
                          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                                (states) => Colors.white.withOpacity(0.9),
                          ),
                          columnSpacing: 20,
                          headingTextStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2193b0),
                          ),
                          dataTextStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          horizontalMargin: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          columns: const [
                            DataColumn(label: Text('Ville')),
                            DataColumn(label: Text('Temp.', maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataColumn(label: Text('Hum.', maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                          rows: List.generate(widget.cities.length, (index) {
                            final city = widget.cities[index];
                            final weather = widget.weathers[index];
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                    (states) => index % 2 == 0
                                    ? Colors.grey[50]!.withOpacity(0.3)
                                    : Colors.white,
                              ),
                              cells: [
                                DataCell(
                                  InkWell(
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Ajout d'un container pour le texte de la ville avec indication visuelle
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.blue[50],
                                            border: Border.all(color: Colors.blue[200]!),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                city.name,
                                                style: TextStyle(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: Colors.blue[700],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[50],
                                    ),
                                    child: Text(
                                      weather.temperature == 0 && weather.description == 'Erreur' ? 'Erreur' : weather.temperature.toStringAsFixed(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[50],
                                      ),
                                      child: Text(
                                        weather.humidity == 0 && weather.description == 'Erreur' ? 'Erreur' : '${weather.humidity}%',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: weather.description == 'Erreur' ? Colors.red : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[200]!.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: widget.onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.refresh, color: Colors.white),
                        const SizedBox(width: 10),
                        const Text('Recommencer', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
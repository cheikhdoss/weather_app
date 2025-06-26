import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/weather.dart';
import 'city_detail_screen.dart';

class ResultScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats météo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>((states) => Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                    columns: const [
                      DataColumn(label: Text('Ville')),
                      DataColumn(label: Text('Température (°C)')),
                      DataColumn(label: Text('Humidité (%)')),
                      DataColumn(label: Text('Vent (km/h)')),
                      DataColumn(label: Text('Code météo')),
                    ],
                    rows: List.generate(cities.length, (index) {
                      final city = cities[index];
                      final weather = weathers[index];
                      return DataRow(
                        cells: [
                          DataCell(
                            GestureDetector(
                              child: Text(city.name, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
                            ),
                          ),
                          DataCell(Text(weather.temperature == 0 && weather.description == 'Erreur' ? 'Erreur' : weather.temperature.toStringAsFixed(1))),
                          DataCell(Text(weather.humidity == 0 && weather.description == 'Erreur' ? 'Erreur' : weather.humidity.toString())),
                          DataCell(Text(weather.windSpeed == 0 && weather.description == 'Erreur' ? 'Erreur' : weather.windSpeed.toStringAsFixed(1))),
                          DataCell(Text(weather.description)),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Recommencer'),
            ),
          ],
        ),
      ),
    );
  }
} 
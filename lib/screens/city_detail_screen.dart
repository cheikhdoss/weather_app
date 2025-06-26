import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/city.dart';
import '../models/weather.dart';

class CityDetailScreen extends StatelessWidget {
  final City city;
  final Weather weather;

  const CityDetailScreen({super.key, required this.city, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail - ${city.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ville : ${city.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Température : ${weather.temperature} °C'),
                      Text('Humidité : ${weather.humidity} %'),
                      Text('Vent : ${weather.windSpeed} km/h'),
                      Text('Code météo : ${weather.description}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(city.lat, city.lon),
                zoom: 10,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(city.name),
                  position: LatLng(city.lat, city.lon),
                  infoWindow: InfoWindow(title: city.name),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
} 
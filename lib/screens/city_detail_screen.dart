import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;
import '../models/city.dart';
import '../models/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class CityDetailScreen extends StatefulWidget {
  final City city;
  final Weather weather;

  const CityDetailScreen({super.key, required this.city, required this.weather});

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  bool _isMapExpanded = false;
  late AnimationController _animationController;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(Duration.zero, () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!,
              Colors.blue[400]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAppBar(),
                    Expanded(
                      flex: 2,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: _buildWeatherCard(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildPlatformMap(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FadeInRight(
        duration: const Duration(milliseconds: 1000),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.refresh, color: Colors.blue[800]),
          onPressed: () {
            // Add refresh functionality here
          },
        ),
      ),
    );
  }

  Widget _buildPlatformMap() {
    if (Platform.isAndroid || Platform.isIOS) {
      return _buildMap();
    } else {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Carte non disponible sur cette plateforme.',
              style: TextStyle(fontSize: 18, color: Colors.blue[800]),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  List<Color> _getWeatherGradient() {
    String description = widget.weather.description.toLowerCase();

    switch (description) {
      case 'clear':
        return [const Color(0xFF1E88E5), const Color(0xFF64B5F6)];
      case 'clouds':
        return [const Color(0xFF546E7A), const Color(0xFF90A4AE)];
      case 'rain':
        return [const Color(0xFF303F9F), const Color(0xFF5C6BC0)];
      case 'snow':
        return [const Color(0xFF78909C), const Color(0xFFCFD8DC)];
      default:
        return [Colors.blue[800]!, Colors.blue[400]!];
    }
  }

  Widget _buildWeatherBackground() {
    String description = widget.weather.description.toLowerCase();

    switch (description) {
      case 'clear':
        return _buildSunnyBackground();
      case 'clouds':
        return _buildCloudyBackground();
      case 'rain':
        return _buildRainyBackground();
      case 'snow':
        return _buildSnowyBackground();
      default:
        return Container();
    }
  }

  Widget _buildSunnyBackground() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.yellow[400]!,
                  Colors.yellow[600]!.withOpacity(0.5),
                  Colors.yellow[600]!.withOpacity(0),
                ],
                stops: const [0.2, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow[600]!.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCloudyBackground() {
    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 20,
          child: Opacity(
            opacity: 0.7,
            child: Image.network(
              'https://www.freepnglogos.com/uploads/cloud-png/cloud-png-17.png',
              width: 100,
              height: 60,
              color: Colors.white.withOpacity(0.9),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: 50,
          child: Opacity(
            opacity: 0.5,
            child: Image.network(
              'https://www.freepnglogos.com/uploads/cloud-png/cloud-png-17.png',
              width: 120,
              height: 70,
              color: Colors.white.withOpacity(0.9),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRainyBackground() {
    return Stack(
      children: [
        // Nuages
        _buildCloudyBackground(),

        // Effet de pluie
        Positioned.fill(
          child: Opacity(
            opacity: 0.4,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.gifer.com/Prl.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSnowyBackground() {
    return Stack(
      children: [
        // Effet de neige
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.gifer.com/7U6d.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.city.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _getWeatherDescription(),
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Action pour partager ou ajouter aux favoris
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ajouté aux favoris'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeatherDescription() {
    String description = widget.weather.description.toLowerCase();

    switch (description) {
      case 'clear':
        return 'Ensoleillé';
      case 'clouds':
        return 'Nuageux';
      case 'rain':
        return 'Pluvieux';
      case 'snow':
        return 'Neigeux';
      case 'erreur':
        return 'Données indisponibles';
      default:
        return description.substring(0, 1).toUpperCase() + description.substring(1);
    }
  }

  Widget _buildWeatherCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.9),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.weather.temperature.toStringAsFixed(1)}°C',
                          style: GoogleFonts.montserrat(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: _getWeatherColor(),
                          ),
                        ),
                        Text(
                          'Ressenti: ${(widget.weather.temperature - 1 + math.Random().nextDouble() * 2).toStringAsFixed(1)}°C',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    _buildWeatherIconLarge(),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, thickness: 1, color: Colors.black12),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherDetailItem(
                      Icons.water_drop,
                      'Humidité',
                      '${widget.weather.humidity}%',
                    ),
                    _buildWeatherDetailItem(
                      Icons.air,
                      'Vent',
                      '${widget.weather.windSpeed} km/h',
                    ),
                    _buildWeatherDetailItem(
                      Icons.compress,
                      'Pression',
                      '${1013 + (math.Random().nextInt(30) - 15)} hPa',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _getWeatherColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: _getWeatherColor()),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getWeatherAdvice(),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getWeatherAdvice() {
    String description = widget.weather.description.toLowerCase();

    switch (description) {
      case 'clear':
        return 'Journée idéale pour des activités en plein air. N\'oubliez pas votre protection solaire !';
      case 'clouds':
        return 'Temps couvert aujourd\'hui. Prévoyez une veste légère pour vos sorties.';
      case 'rain':
        return 'N\'oubliez pas votre parapluie et vos chaussures imperméables !';
      case 'snow':
        return 'Routes glissantes, soyez prudent. Habillez-vous chaudement pour sortir.';
      default:
        return 'Consultez régulièrement les prévisions météo pour planifier votre journée.';
    }
  }

  Widget _buildWeatherDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: _getWeatherColor(), size: 24),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getWeatherColor() {
    String description = widget.weather.description.toLowerCase();

    switch (description) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.blueGrey;
      case 'rain':
        return Colors.indigo;
      case 'snow':
        return Colors.lightBlue;
      default:
        return Colors.blue;
    }
  }

  Widget _buildWeatherIconLarge() {
    String description = widget.weather.description.toLowerCase();
    IconData icon;

    switch (description) {
      case 'clear':
        icon = Icons.wb_sunny_rounded;
        break;
      case 'clouds':
        icon = Icons.cloud_rounded;
        break;
      case 'rain':
        icon = Icons.umbrella_rounded;
        break;
      case 'snow':
        icon = Icons.ac_unit_rounded;
        break;
      default:
        icon = Icons.wb_cloudy_rounded;
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: _getWeatherColor().withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: _getWeatherColor(),
        size: 40,
      ),
    );
  }

  Widget _buildMap() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(_isMapExpanded ? 0 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isMapExpanded ? 0 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_isMapExpanded ? 0 : 20),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.city.lat, widget.city.lon),
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.city.name),
                  position: LatLng(widget.city.lat, widget.city.lon),
                  infoWindow: InfoWindow(
                    title: widget.city.name,
                    snippet: '${widget.weather.temperature}°C, ${_getWeatherDescription()}',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false, // Nous utiliserons nos propres contrôles
              mapType: MapType.normal,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),

            // Contrôles personnalisés pour la carte
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.blue[900]),
                      onPressed: () {
                        _mapController.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.remove, color: Colors.blue[900]),
                      onPressed: () {
                        _mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bouton pour agrandir/réduire la carte
            if (!_isMapExpanded) Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      _isMapExpanded = true;
                    });
                  },
                ),
              ),
            ),

            // Bouton pour réduire la carte en plein écran
            if (_isMapExpanded) Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      _isMapExpanded = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon() {
    String description = widget.weather.description.toLowerCase();
    IconData icon;

    switch (description) {
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
      default:
        icon = Icons.wb_cloudy;
    }

    return Icon(
      icon,
      color: _getWeatherColor(),
      size: 32,
    );
  }
}
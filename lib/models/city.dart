class City {
  final String name;
  final double lat;
  final double lon;

  const City({required this.name, required this.lat, required this.lon});
}

const List<City> senegalCities = [
  City(name: 'Dakar', lat: 14.7167, lon: -17.4677),
  City(name: 'Saint-Louis', lat: 16.0179, lon: -16.4896),
  City(name: 'Thiès', lat: 14.7918, lon: -16.9256),
  City(name: 'Ziguinchor', lat: 12.5833, lon: -16.2719),
  City(name: 'Kaolack', lat: 14.1833, lon: -16.2500),
]; 
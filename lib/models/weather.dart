class Weather {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  factory Weather.fromOpenMeteoJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    final humidity = (json['hourly'] != null && json['hourly']['relative_humidity_2m'] != null)
        ? (json['hourly']['relative_humidity_2m'] as List).isNotEmpty
            ? (json['hourly']['relative_humidity_2m'][0] as num).toInt()
            : 0
        : 0;
    return Weather(
      temperature: (current['temperature'] as num).toDouble(),
      description: 'Code météo:  0${current['weathercode']}',
      humidity: humidity,
      windSpeed: (current['windspeed'] as num).toDouble(),
    );
  }
} 
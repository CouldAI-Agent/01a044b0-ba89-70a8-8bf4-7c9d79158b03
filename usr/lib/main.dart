import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RealWeatherApp());
}

class RealWeatherApp extends StatelessWidget {
  const RealWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Real',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WeatherScreen(),
      },
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? weatherData;
  
  // Por defecto, usaremos las coordenadas de Madrid
  double lat = 40.4165;
  double lon = -3.7026;
  String cityName = 'Madrid, España';

  final List<Map<String, dynamic>> cities = [
    {'name': 'Madrid, España', 'lat': 40.4165, 'lon': -3.7026},
    {'name': 'Ciudad de México, México', 'lat': 19.4326, 'lon': -99.1332},
    {'name': 'Buenos Aires, Argentina', 'lat': -34.6037, 'lon': -58.3816},
    {'name': 'Bogotá, Colombia', 'lat': 4.7110, 'lon': -74.0721},
    {'name': 'Santiago, Chile', 'lat': -33.4489, 'lon': -70.6693},
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather(lat, lon, cityName);
  }

  Future<void> fetchWeather(double latitude, double longitude, String name) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      cityName = name;
    });

    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al obtener datos del clima (Código: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión: Verifica tu internet';
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(int weatherCode) {
    // Códigos WMO de Open-Meteo
    if (weatherCode == 0) return Icons.wb_sunny;
    if (weatherCode >= 1 && weatherCode <= 3) return Icons.cloud;
    if (weatherCode >= 45 && weatherCode <= 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 67) return Icons.water_drop;
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.shower;
    if (weatherCode >= 95) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }

  String getWeatherDescription(int weatherCode) {
    if (weatherCode == 0) return 'Despejado';
    if (weatherCode >= 1 && weatherCode <= 3) return 'Parcialmente Nublado';
    if (weatherCode >= 45 && weatherCode <= 48) return 'Niebla';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Lluvia Ligera / Llovizna';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Nieve';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Chubascos';
    if (weatherCode >= 95) return 'Tormenta Eléctrica';
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Real'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchWeather(lat, lon, cityName),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: cityName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Seleccionar Ciudad',
                  prefixIcon: const Icon(Icons.location_city),
                ),
                items: cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city['name'] as String,
                    child: Text(city['name'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedCity = cities.firstWhere((c) => c['name'] == value);
                    lat = selectedCity['lat'] as double;
                    lon = selectedCity['lon'] as double;
                    fetchWeather(lat, lon, value);
                  }
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        )
                      : weatherData != null
                          ? _buildWeatherContent()
                          : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final current = weatherData!['current_weather'];
    final temp = current['temperature'];
    final windspeed = current['windspeed'];
    final weatherCode = current['weathercode'];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(weatherCode),
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              cityName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              getWeatherDescription(weatherCode),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Text(
              '${temp.round()}°C',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDetailItem(Icons.air, 'Viento', '$windspeed km/h'),
                  _buildDetailItem(Icons.thermostat, 'Temperatura', '$temp°C'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

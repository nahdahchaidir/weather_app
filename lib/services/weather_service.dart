import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';

  // daftar kota yg bisa dipilih (pakai kode adm4 Kemendagri)
  static const List<Map<String, String>> daftarKotaPilihan = [
    {
      'nama': 'Jakarta Pusat (Kemayoran)',
      'kode': '31.71.03.1001',
    },
    {
      'nama': 'Makassar (Panakkukang)',
      'kode': '73.71.09.1003',
    },
    {
      'nama': 'Surabaya (Tegalsari)',
      'kode': '35.78.05.1002',
    },
    {
      'nama': 'Bandung (Cicendo)',
      'kode': '32.73.06.1001',
    },
    {
      'nama': 'Yogyakarta (Gondokusuman)',
      'kode': '34.71.03.1003',
    },
    {
      'nama': 'Denpasar (Denpasar Selatan)',
      'kode': '51.71.01.1001',
    },
    {
      'nama': 'Medan (Medan Maimun)',
      'kode': '12.71.15.1001',
    },
  ];

  // ambil data prakiraan cuaca dari API BMKG
  Future<WeatherModel> fetchWeather(String adm4Code) async {
    final uri = Uri.parse('$_baseUrl?adm4=$adm4Code');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'FlutterWeatherApp/1.0',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Data cuaca untuk kode wilayah ini tidak ditemukan.');
      } else {
        throw Exception(
          'Server BMKG error, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}

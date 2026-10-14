import 'package:flutter/foundation.dart';

// model data lokasi dari api bmkg
@immutable
class LokasiModel {
  final String adm1;
  final String adm2;
  final String adm3;
  final String adm4;
  final String provinsi;
  final String kotkab;
  final String kecamatan;
  final String desa;
  final double lat;
  final double lon;
  final String timezone;

  const LokasiModel({
    required this.adm1,
    required this.adm2,
    required this.adm3,
    required this.adm4,
    required this.provinsi,
    required this.kotkab,
    required this.kecamatan,
    required this.desa,
    required this.lat,
    required this.lon,
    required this.timezone,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return LokasiModel(
      adm1: json['adm1']?.toString() ?? '',
      adm2: json['adm2']?.toString() ?? '',
      adm3: json['adm3']?.toString() ?? '',
      adm4: json['adm4']?.toString() ?? '',
      provinsi: json['provinsi']?.toString() ?? '',
      kotkab: json['kotkab']?.toString() ?? '',
      kecamatan: json['kecamatan']?.toString() ?? '',
      desa: json['desa']?.toString() ?? '',
      lat: parseDouble(json['lat']),
      lon: parseDouble(json['lon']),
      timezone: json['timezone']?.toString() ?? '',
    );
  }
}

// data cuaca per 3 jam
@immutable
class CuacaItemModel {
  final String datetime;
  final String utcDatetime;
  final String localDatetime;
  final String analysisDate;
  final int suhu; // t
  final int kelembapan; // hu
  final int tutupanAwan; // tcc
  final double curahHujan; // tp
  final int weatherCode; // weather
  final String weatherDesc;
  final String weatherDescEn;
  final double kecepatanAngin; // ws
  final String arahAngin; // wd
  final String arahAnginTuju; // wd_to
  final int arahAnginDerajat; // wd_deg
  final String jarakPandang; // vs_text
  final String image;

  const CuacaItemModel({
    required this.datetime,
    required this.utcDatetime,
    required this.localDatetime,
    required this.analysisDate,
    required this.suhu,
    required this.kelembapan,
    required this.tutupanAwan,
    required this.curahHujan,
    required this.weatherCode,
    required this.weatherDesc,
    required this.weatherDescEn,
    required this.kecepatanAngin,
    required this.arahAngin,
    required this.arahAnginTuju,
    required this.arahAnginDerajat,
    required this.jarakPandang,
    required this.image,
  });

  factory CuacaItemModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // vs_text bisa null dari API
    String vsText = 'N/A';
    if (json['vs_text'] != null) {
      vsText = json['vs_text'].toString();
    }

    // handle spasi di URL image (kayak di contoh PHP BMKG)
    String imageUrl = '';
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imageUrl = json['image'].toString().replaceAll(' ', '%20');
    }

    return CuacaItemModel(
      datetime: json['datetime']?.toString() ?? '',
      utcDatetime: json['utc_datetime']?.toString() ?? '',
      localDatetime: json['local_datetime']?.toString() ?? '',
      analysisDate: json['analysis_date']?.toString() ?? '',
      suhu: parseInt(json['t']),
      kelembapan: parseInt(json['hu']),
      tutupanAwan: parseInt(json['tcc']),
      curahHujan: parseDouble(json['tp']),
      weatherCode: parseInt(json['weather']),
      weatherDesc: json['weather_desc']?.toString() ?? 'N/A',
      weatherDescEn: json['weather_desc_en']?.toString() ?? 'N/A',
      kecepatanAngin: parseDouble(json['ws']),
      arahAngin: json['wd']?.toString() ?? '-',
      arahAnginTuju: json['wd_to']?.toString() ?? '-',
      arahAnginDerajat: parseInt(json['wd_deg']),
      jarakPandang: vsText,
      image: imageUrl,
    );
  }
}

// model utama penampung cuaca
@immutable
class WeatherModel {
  final LokasiModel lokasi;
  final CuacaItemModel cuacaSekarang;
  final List<CuacaItemModel> cuacaHariIni;
  final List<List<CuacaItemModel>> semuaPrakiraan;

  const WeatherModel({
    required this.lokasi,
    required this.cuacaSekarang,
    required this.cuacaHariIni,
    required this.semuaPrakiraan,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // parse lokasi
    final lokasiMap = json['lokasi'] as Map<String, dynamic>? ?? {};
    final lokasi = LokasiModel.fromJson(lokasiMap);

    // parse data cuaca: data[0]["cuaca"] -> array hari -> array jam
    final dataList = json['data'] as List<dynamic>? ?? [];
    List<List<CuacaItemModel>> daftarHari = [];

    if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
      final cuacaNested = dataList[0]['cuaca'] as List<dynamic>? ?? [];
      for (var hari in cuacaNested) {
        if (hari is List) {
          final items = hari
              .map((item) =>
                  CuacaItemModel.fromJson(item as Map<String, dynamic>))
              .toList();
          daftarHari.add(items);
        }
      }
    }

    // gabung semua item buat cari yg paling deket sama waktu sekarang
    final semuaItem = daftarHari.expand((list) => list).toList();
    final cuacaHariIni =
        daftarHari.isNotEmpty ? daftarHari[0] : <CuacaItemModel>[];

    // cari cuaca yg paling deket waktunya
    CuacaItemModel cuacaSekarang;
    if (semuaItem.isNotEmpty) {
      final now = DateTime.now();
      CuacaItemModel? closest;
      int minDiff = 99999999;

      for (var item in semuaItem) {
        try {
          final dt = DateTime.parse(item.localDatetime.replaceAll(' ', 'T'));
          final diff = (dt.difference(now).inMinutes).abs();
          if (diff < minDiff) {
            minDiff = diff;
            closest = item;
          }
        } catch (_) {}
      }
      cuacaSekarang = closest ?? semuaItem[0];
    } else {
      cuacaSekarang = const CuacaItemModel(
        datetime: '',
        utcDatetime: '',
        localDatetime: '',
        analysisDate: '',
        suhu: 0,
        kelembapan: 0,
        tutupanAwan: 0,
        curahHujan: 0,
        weatherCode: 1,
        weatherDesc: 'N/A',
        weatherDescEn: 'N/A',
        kecepatanAngin: 0,
        arahAngin: '-',
        arahAnginTuju: '-',
        arahAnginDerajat: 0,
        jarakPandang: 'N/A',
        image: '',
      );
    }

    return WeatherModel(
      lokasi: lokasi,
      cuacaSekarang: cuacaSekarang,
      cuacaHariIni: cuacaHariIni,
      semuaPrakiraan: daftarHari,
    );
  }
}

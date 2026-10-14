# Weather App - Prakiraan Cuaca BMKG

**Nama**: Nahdah Fauziah Chaidir  

---

## Tentang Aplikasi
Aplikasi ini dibuat untuk tugas praktikum pemrograman mobile. Saya menggunakan API dari BMKG untuk menampilkan data prakiraan cuaca di beberapa kota di Indonesia.

Data diambil dari endpoint:
```
https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4={kode_wilayah}
```

Fitur yang ada di aplikasi:
- Pilih kota (Jakarta, Makassar, Surabaya, Bandung, Yogyakarta, Denpasar, Medan)
- Lihat suhu, kelembapan, angin, tutupan awan, curah hujan
- Prakiraan per 3 jam
- Prakiraan 3 hari ke depan
- Pull to refresh
- Tombol coba lagi kalau error

---

## Struktur Folder

```
lib/
├── main.dart
├── models/
│   └── weather_model.dart       --> class data dari JSON BMKG
├── services/
│   └── weather_service.dart     --> panggil API pakai http
└── ui/
    ├── screens/
    │   └── weather_screen.dart  --> halaman utama, atur loading/error/sukses
    └── widgets/
        ├── city_selector_widget.dart
        ├── current_weather_card.dart
        ├── daily_forecast_list.dart
        ├── hourly_forecast_list.dart
        └── weather_metrics_grid.dart
```

- `models/` - class immutable pakai factory fromJson
- `services/` - satu-satunya file yang import http
- `ui/screens/` - StatefulWidget yang handle state
- `ui/widgets/` - komponen UI terima data lewat constructor

---

## Cara Jalankan

```bash
cd weather_app
flutter pub get
flutter run -d chrome
```

---

## Sumber Data

Data cuaca dari **BMKG** (Badan Meteorologi, Klimatologi, dan Geofisika)  
https://data.bmkg.go.id/prakiraan-cuaca

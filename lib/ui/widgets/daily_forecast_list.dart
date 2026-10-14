import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<List<CuacaItemModel>> semuaPrakiraan;

  const DailyForecastList({
    super.key,
    required this.semuaPrakiraan,
  });

  IconData _getWeatherIcon(int code) {
    switch (code) {
      case 0:
      case 1:
        return Icons.wb_sunny_rounded;
      case 2:
        return Icons.wb_cloudy_rounded;
      case 3:
      case 4:
        return Icons.cloud_rounded;
      case 60:
      case 61:
      case 63:
      case 80:
        return Icons.water_drop_rounded;
      case 95:
      case 97:
        return Icons.flash_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  Color _getWeatherColor(int code) {
    switch (code) {
      case 0:
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFF0EA5E9);
      case 3:
      case 4:
        return const Color(0xFF64748B);
      case 60:
      case 61:
      case 63:
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (semuaPrakiraan.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prakiraan 3 Hari ke Depan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            children: List.generate(semuaPrakiraan.length, (index) {
              final hariData = semuaPrakiraan[index];
              if (hariData.isEmpty) return const SizedBox();

              // Hitung suhu min & max
              int suhuMin = hariData
                  .map((e) => e.suhu)
                  .reduce((a, b) => a < b ? a : b);
              int suhuMax = hariData
                  .map((e) => e.suhu)
                  .reduce((a, b) => a > b ? a : b);

              final middleItem = hariData[hariData.length ~/ 2];
              final icon = _getWeatherIcon(middleItem.weatherCode);
              final iconColor = _getWeatherColor(middleItem.weatherCode);

              // Format nama hari
              String namaHari;
              try {
                final dt = DateTime.parse(
                  hariData.first.localDatetime.replaceAll(' ', 'T'),
                );
                final hariList = [
                  'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
                ];
                final bulanList = [
                  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
                ];
                namaHari =
                    '${hariList[dt.weekday - 1]}, ${dt.day} ${bulanList[dt.month - 1]}';
              } catch (_) {
                namaHari = 'Hari ke-${index + 1}';
              }

              final labelHari = index == 0
                  ? 'Hari ini'
                  : (index == 1 ? 'Besok' : 'Lusa');

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        // Nama Hari & Tanggal
                        SizedBox(
                          width: 82,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labelHari,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                namaHari,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Icon Cuaca & Deskripsi
                        Expanded(
                          child: Row(
                            children: [
                              Icon(icon, size: 20, color: iconColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  middleItem.weatherDesc,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF334155),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rentang Temperatur
                        Row(
                          children: [
                            Text(
                              '$suhuMin°',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Bar rentang gradasi
                            Container(
                              width: 44,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF38BDF8),
                                    Color(0xFFF59E0B),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$suhuMax°',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index < semuaPrakiraan.length - 1)
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

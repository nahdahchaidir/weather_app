import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LokasiModel lokasi;
  final CuacaItemModel cuaca;

  const CurrentWeatherCard({
    super.key,
    required this.lokasi,
    required this.cuaca,
  });

  bool _isNight(String localDatetime) {
    try {
      final dt = DateTime.parse(localDatetime.replaceAll(' ', 'T'));
      return dt.hour < 6 || dt.hour >= 18;
    } catch (_) {
      final now = DateTime.now();
      return now.hour < 6 || now.hour >= 18;
    }
  }

  List<Color> _getWeatherGradients(int code, bool night) {
    if (night) {
      return [const Color(0xFF0F172A), const Color(0xFF1E293B)];
    }
    switch (code) {
      case 0:
      case 1:
        // Cerah
        return [const Color(0xFF2563EB), const Color(0xFF38BDF8)];
      case 2:
        // Cerah berawan
        return [const Color(0xFF1D4ED8), const Color(0xFF60A5FA)];
      case 3:
      case 4:
        // Berawan / mendung
        return [const Color(0xFF334155), const Color(0xFF64748B)];
      case 60:
      case 61:
      case 63:
      case 80:
        // Hujan
        return [const Color(0xFF0369A1), const Color(0xFF0284C7)];
      case 95:
      case 97:
        // Petir
        return [const Color(0xFF312E81), const Color(0xFF4338CA)];
      default:
        return [const Color(0xFF2563EB), const Color(0xFF38BDF8)];
    }
  }

  IconData _getWeatherIcon(int code, bool night) {
    switch (code) {
      case 0:
      case 1:
        return night ? Icons.nightlight_round : Icons.wb_sunny_rounded;
      case 2:
        return night ? Icons.nights_stay_rounded : Icons.wb_cloudy_rounded;
      case 3:
      case 4:
        return Icons.cloud_rounded;
      case 5:
      case 10:
      case 45:
        return Icons.blur_on_rounded;
      case 60:
      case 61:
        return Icons.water_drop_rounded;
      case 63:
      case 80:
        return Icons.umbrella_rounded;
      case 95:
      case 97:
        return Icons.flash_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  String _formatLocalDatetime(String localDatetime) {
    try {
      final dt = DateTime.parse(localDatetime.replaceAll(' ', 'T'));
      final hariList = [
        'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
      ];
      final bulanList = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${hariList[dt.weekday - 1]}, ${dt.day} ${bulanList[dt.month - 1]} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return localDatetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final night = _isNight(cuaca.localDatetime);
    final gradients = _getWeatherGradients(cuaca.weatherCode, night);
    final fallbackIcon = _getWeatherIcon(cuaca.weatherCode, night);

    final lokasiUtama = lokasi.desa.isNotEmpty
        ? '${lokasi.desa}, ${lokasi.kecamatan}'
        : (lokasi.kotkab.isNotEmpty ? lokasi.kotkab : 'Indonesia');

    final subLokasi = '${lokasi.kotkab}, ${lokasi.provinsi}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradients,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradients.first.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header lokasi & badge sumber BMKG
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lokasiUtama,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'BMKG LIVE',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Sub judul kota & provinsi
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 2),
              child: Text(
                subLokasi,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bagian tengah: suhu, status cuaca, dan icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cuaca.suhu}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: -2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 2),
                          child: Text(
                            '°C',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        cuaca.weatherDesc,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Icon cuaca dalam circle transparan
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    fallbackIcon,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Garis tipis pembatas
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.16),
            ),

            const SizedBox(height: 12),

            // Footer: waktu update & info koordinat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      cuaca.localDatetime.isNotEmpty
                          ? _formatLocalDatetime(cuaca.localDatetime)
                          : 'Terbaru',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  lokasi.timezone.isNotEmpty ? lokasi.timezone : 'WIB',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

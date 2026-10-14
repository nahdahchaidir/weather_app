import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/weather_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<CuacaItemModel> hourlyList;
  final String activeDatetime;

  const HourlyForecastList({
    super.key,
    required this.hourlyList,
    required this.activeDatetime,
  });

  String _formatJam(String localDatetime) {
    try {
      final dt = DateTime.parse(localDatetime.replaceAll(' ', 'T'));
      return '${dt.hour.toString().padLeft(2, '0')}:00';
    } catch (_) {
      return localDatetime;
    }
  }

  IconData _getMiniIcon(int code) {
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

  Color _getIconColor(int code, bool isCurrent) {
    if (isCurrent) return Colors.white;
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
      case 80:
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hourlyList.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Prakiraan Tiap 3 Jam',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Hari Ini',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyList.length,
            itemBuilder: (context, index) {
              final item = hourlyList[index];
              final isCurrent = item.datetime == activeDatetime;
              final icon = _getMiniIcon(item.weatherCode);
              final iconColor = _getIconColor(item.weatherCode, isCurrent);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 82,
                margin: const EdgeInsets.only(right: 10, bottom: 4),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFF2563EB) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isCurrent
                          ? const Color(0xFF2563EB).withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: isCurrent ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Jam
                    Text(
                      _formatJam(item.localDatetime),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCurrent
                            ? Colors.white.withValues(alpha: 0.9)
                            : const Color(0xFF64748B),
                      ),
                    ),

                    // Icon bulat
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.white.withValues(alpha: 0.2)
                            : iconColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 20, color: iconColor),
                    ),

                    // Suhu
                    Text(
                      '${item.suhu}°',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isCurrent
                            ? Colors.white
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

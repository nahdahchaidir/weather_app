import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CuacaItemModel cuaca;

  const WeatherMetricsGrid({
    super.key,
    required this.cuaca,
  });

  String _getHumidityStatus(int hu) {
    if (hu < 45) return 'Kering';
    if (hu <= 75) return 'Nyaman';
    return 'Lembap';
  }

  String _getWindStatus(double ws) {
    if (ws < 5) return 'Tenang';
    if (ws <= 19) return 'Sepoi-sepoi';
    return 'Kencang';
  }

  String _getCloudStatus(int tcc) {
    if (tcc < 25) return 'Cerah';
    if (tcc <= 60) return 'Sebagian';
    return 'Mendung';
  }

  String _getRainStatus(double tp) {
    if (tp == 0) return 'Nihil';
    if (tp <= 5) return 'Ringan';
    if (tp <= 20) return 'Sedang';
    return 'Lebat';
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color primaryColor,
    required Color backgroundColor,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Baris Atas: Icon bulat & Chip Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),

          // Nilai & Judul Metrik
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 3.5,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kondisi Atmosfer',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.22,
          children: [
            // 1. Kelembapan (hu)
            _buildMetricCard(
              icon: Icons.water_drop_rounded,
              title: 'Kelembapan Udara',
              value: '${cuaca.kelembapan}%',
              status: _getHumidityStatus(cuaca.kelembapan),
              primaryColor: const Color(0xFF0284C7),
              backgroundColor: const Color(0xFFF0F9FF),
              progress: cuaca.kelembapan / 100.0,
            ),

            // 2. Kecepatan & Arah Angin (ws, wd)
            _buildMetricCard(
              icon: Icons.air_rounded,
              title: 'Angin (${cuaca.arahAngin})',
              value: '${cuaca.kecepatanAngin.toStringAsFixed(1)} km/j',
              status: _getWindStatus(cuaca.kecepatanAngin),
              primaryColor: const Color(0xFF0D9488),
              backgroundColor: const Color(0xFFF0FDF4),
              progress: (cuaca.kecepatanAngin / 30.0),
            ),

            // 3. Tutupan Awan (tcc)
            _buildMetricCard(
              icon: Icons.cloud_rounded,
              title: 'Tutupan Awan',
              value: '${cuaca.tutupanAwan}%',
              status: _getCloudStatus(cuaca.tutupanAwan),
              primaryColor: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFFEEF2FF),
              progress: cuaca.tutupanAwan / 100.0,
            ),

            // 4. Curah Hujan (tp)
            _buildMetricCard(
              icon: Icons.umbrella_rounded,
              title: 'Curah Hujan',
              value: '${cuaca.curahHujan.toStringAsFixed(1)} mm',
              status: _getRainStatus(cuaca.curahHujan),
              primaryColor: const Color(0xFF2563EB),
              backgroundColor: const Color(0xFFEFF6FF),
              progress: (cuaca.curahHujan / 25.0),
            ),
          ],
        ),
      ],
    );
  }
}

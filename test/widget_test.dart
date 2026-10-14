import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Aplikasi Cuaca BMKG smoke test', (WidgetTester tester) async {
    // Build app dan render
    await tester.pumpWidget(const MyApp());

    // Cek apakah judul AppBar muncul
    expect(find.text('Info Cuaca BMKG'), findsOneWidget);
  });
}

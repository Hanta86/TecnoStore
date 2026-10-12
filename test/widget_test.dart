import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_movil/main.dart';

void main() {
  testWidgets('TecnoStore muestra el catálogo', (tester) async {
    await tester.pumpWidget(const TecnoStoreApp());

    expect(find.text('TecnoStore'), findsOneWidget);
    expect(find.text('Audífonos Bluetooth'), findsOneWidget);
  });
}

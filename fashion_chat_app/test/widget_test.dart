import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_chat_app/main.dart';

void main() {
  testWidgets('Departments screen loads correctly',
      (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    expect(find.text('Fashion Store'), findsOneWidget);
    expect(find.text('Women'), findsOneWidget);
    expect(find.text('Men'), findsOneWidget);
    expect(find.text('Kids'), findsOneWidget);
  });
}
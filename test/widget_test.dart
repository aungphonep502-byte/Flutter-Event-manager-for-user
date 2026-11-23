
import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_app/main.dart';

void main() {
  testWidgets('Event Attendee App loads',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const EventAttendeeApp(),
        );

        expect(
          find.text('Available Events'),
          findsOneWidget,
        );
      });
}

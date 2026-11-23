import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/event_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connect the app to the existing Firebase project.
  await Firebase.initializeApp(
    //Gets the correct Firebase settings for the platform I am using.
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //sets up the app's basic structure, theme, colours and first screen
  runApp(const EventAttendeeApp());
}
// Main widget of the application.
// StatelessWidget is used because it does not manage changing data.
class EventAttendeeApp extends StatelessWidget {
  // Creates the main application widget.
  const EventAttendeeApp({super.key});
  // Uses the build method from the parent class.
  @override
  // Builds and returns the user interface of the application.
  Widget build(BuildContext context) {
    //basic structure
    return MaterialApp(
      // Hides the DEBUG banner in the top-right corner of the app.
      debugShowCheckedModeBanner: false,
      title: 'Event Attendee App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const EventListScreen(),
    );
  }
}

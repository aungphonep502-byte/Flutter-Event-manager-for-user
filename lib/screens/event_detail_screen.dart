import 'package:flutter/material.dart';
import '../models/event_data.dart';
// Shows the details of one selected event.
class EventDetailScreen extends StatelessWidget {
  // Stores the selected event information.
  final EventData event;
  // Receives the selected event when this screen opens.
  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Creates the event details screen.
    return Scaffold(
      // Creates the top app bar.
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Allows users to scroll if the content is too long
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        // Places the event information vertically.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displays the event name.
            Text(
              event.eventName,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Displays the main event information.
            detailRow('Date', event.date),
            detailRow('Location', event.location),
            detailRow('Organizer', event.organizer),
            detailRow('Event Type', event.type),
            detailRow('Status', event.status),
            // Adds a line to separate the sections.
            const Divider(height: 30),
            // Displays the description heading.
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Shows the description or a message if it is empty.
            Text(
              event.description.isEmpty
                  ? 'No description available.'
                  : event.description,
            ),
            // Separates the description from contact information.
            const Divider(height: 30),

            detailRow('Contact Email', event.contactEmail),
            detailRow('Contact Phone', event.contactPhone),
          ],
        ),
      ),
    );
  }
  // Creates a row to display one piece of event information.
  Widget detailRow(String title, String value) {
    return Padding(
      // Adds space below each information row.
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sets a fixed width for the information title.
          SizedBox(
            width: 115,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Uses the remaining space to display the information.
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
            ),
          ),
        ],
      ),
    );
  }
}

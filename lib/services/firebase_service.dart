import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_data.dart';

class FirebaseService {
  // Gets the Firestore database instance so the app can access Firestore.
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Get events from the Firestore events collection.
  Stream<List<EventData>> getEvents() {
    return _firestore
    // Access the events collection in Firestore.
        .collection('events')
    // Listen for changes in Firestore.
    //So the app can receive updated data automatically when Firestore changes.
        .snapshots()
        .map((snapshot) {
      // Goes through each document in the snapshot.
      return snapshot.docs.map((document) {
        // Converts the document data into an EventData object.
        // Also passes the document ID to identify the event.
        return EventData.fromFirestore(
          document.data(),
          document.id,
        );
        // Converts the list of events into a normal List.
      }).toList();
    });
  }
}

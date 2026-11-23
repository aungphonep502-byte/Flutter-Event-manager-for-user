// Stores all information about one event.
class EventData {
  final String documentId;
  final int id;
  final String eventName;
  final String date;
  final String location;
  final String organizer;
  final String type;
  final String status;
  final String description;
  final String contactEmail;
  final String contactPhone;
  // Constructor:  creates an EventData object
  EventData({
    // Requires an ID for each field.
    // 'this' assigns the given value to the field.
    required this.documentId,
    required this.id,
    required this.eventName,
    required this.date,
    required this.location,
    required this.organizer,
    required this.type,
    required this.status,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
  });

  // Convert Firestore document data into an EventData object.
  factory EventData.fromFirestore(
      Map<String, dynamic> data,
      String documentId,
      ) {
    // Creates an object using the Firestore data.
    return EventData(
      // Gets the event ID.
      // Uses the document ID if the event ID is missing.
      // Uses 0 if both are missing or invalid.
      documentId: documentId,
      id: (data['id'] as num?)?.toInt() ??
          int.tryParse(documentId) ?? 0,
      // Gets the event name.
      // Uses an empty string if missing.
      eventName: data['eventName']?.toString() ?? '',
      date: data['date']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      organizer: data['organizer']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      contactEmail: data['contactEmail']?.toString() ?? '',
      contactPhone: data['contactPhone']?.toString() ?? '',
    );
  }
}

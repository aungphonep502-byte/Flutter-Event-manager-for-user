import 'package:flutter/material.dart';

import '../models/event_data.dart';
import '../services/firebase_service.dart';
import '../services/favourite_service.dart';
import 'event_detail_screen.dart';
//Creates the screen widget
class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  //Creates and returns the State object for this screen
  //_EventListScreenState contains the changing data and screen functionality.
  //The StatefulWidget itself does not store the changing screen data. Its State class manages
  State<EventListScreen> createState() => _EventListScreenState();
}
//Manages changing data and UI
class _EventListScreenState extends State<EventListScreen> {
  //this screen can call Firebase functions to retrieve event information
  final FirebaseService _firebaseService = FirebaseService();
  //this screen can call functions to save and remove favourite event ID
  final FavouriteService _favouriteService = FavouriteService();
  //To control and access the text entered by the user.
  final TextEditingController _nameController =
  TextEditingController();
  //To control and access the date search text.
  final TextEditingController _dateController =
  TextEditingController();
  //To filter events by name.
  String nameSearch = '';
  String dateSearch = ''; //To filter events by date.

  Set<String> favouriteIds = {}; //To identify favourite events.

  int selectedIndex = 0; //To switch between All Events and Favourites.
  bool isLoadingFavourites = true; //	To show a loading indicator while retrieving saved IDs.

  @override
  void initState() { //This function runs when the screen is first created.
    super.initState(); //Calls the original initState() from the parent class.
    loadFavourites(); //Calls the function that loads the user's saved favourite IDs.
  }

  // Load saved favourites when the app opens.
  //Create a function that loads favourite data in the background.
  Future<void> loadFavourites() async {
    final savedFavourites =
    await _favouriteService.getFavourites(); //Get the saved favourite IDs and wait until they are loaded.
    //If the screen has closed, stop this function.
    if (!mounted) return;
    //Tell Flutter to refresh the screen after updating the data.
    setState(() {
      //Update the screen's favourite ID list with the saved IDs.
      favouriteIds = savedFavourites;
      isLoadingFavourites = false; //Tell the app that favourite loading is complete.
    });
  }

  // Add or remove an event from favourites.
  //Create a function to change an event's favourite status.
  Future<void> toggleFavourite(EventData event) async {
    final eventId = event.documentId; //Get the selected event's unique Firestore ID
    //Check whether this event is already a favourite.
    if (favouriteIds.contains(eventId)) {
      //If it returns true, the event is already a favourite
      //If the event is already a favourite – Remove it
      await _favouriteService.removeFavourite(eventId);

      if (!mounted) return;
      //Stop if the screen has already closed.
      setState(() {
        favouriteIds.remove(eventId);
      });
    } else {
      //if not exist yet, add it
      await _favouriteService.addFavourite(eventId);

      if (!mounted) return;

      setState(() {
        favouriteIds.add(eventId);
      });
    }
  }
//Check whether an event is available to display.
  bool isAvailable(EventData event) {
    //Get the event status and make it lowercase.
    final status = event.status.toLowerCase();
    //The event must not be cancelled or completed
    return status != 'cancelled' &&
        status != 'completed';
  }
  //Create a function to filter the event list.
  List<EventData> filterEvents(List<EventData> events) {
    return events.where((event) {
      final matchesName = event.eventName
          .toLowerCase()
          .contains(nameSearch.toLowerCase()); //Check whether the event name includes the search text.

      final matchesDate = event.date
          .toLowerCase()
          .contains(dateSearch.toLowerCase());

      final isFavourite =
      favouriteIds.contains(event.documentId); //Check whether this event is already a favourite.

      final matchesFavouritePage =
          selectedIndex == 0 || isFavourite; //Check whether the event should appear in the selected tab.

      return isAvailable(event) &&
          matchesName &&
          matchesDate &&
          matchesFavouritePage;
      //Combines four conditions to decide whether the event should be included in the result.
      // && means all four conditions must be true.
    }).toList(); //We use .toList() to convert the filtered results into the required return type.
  }
  //It cleans up the controllers when the screen is closed or removed,
  // preventing unnecessary memory usage and resource leaks.
  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? 'Available Events'
              : 'Favourite Events',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Search fields.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Search event name',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nameSearch = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Search event date (e.g. 2026-11-20)',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      dateSearch = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Event list from Firestore.
          //To load events from Firebase, show loading indicators while waiting,
          // handle errors, and automatically receive updated event data without manually refreshing the screen.
          Expanded( //Takes the remaining available screen space.
            child: isLoadingFavourites
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : StreamBuilder<List<EventData>>( //Listens for data changes.
              stream: _firebaseService.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == //Contains the latest data or error from the stream.
                    ConnectionState.waiting) { //Data is still loading.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) { //Checks whether an error occurred.
                  return Center(
                    child: Text(
                      'Error loading events: ${snapshot.error}',
                    ),
                  );
                }

                final allEvents = snapshot.data ?? [];

                final filteredEvents =
                filterEvents(allEvents);

                if (filteredEvents.isEmpty) {
                  return Center(
                    child: Text(
                      selectedIndex == 0
                          ? 'No available events found.'
                          : 'You have no favourite events yet.',
                    ),
                  );
                }
                //To display filtered events in a scrollable list
                //and check whether each event is marked as a favourite.
                return ListView.builder( //widget
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {  //widget information, item position.
                    final event = filteredEvents[index];

                    final isFavourite = favouriteIds
                        .contains(event.documentId);
                    //
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.all(16),

                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.event,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          event.eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        subtitle: Padding(
                          padding:
                          const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${event.date}'),
                              Text(
                                'Location: ${event.location}',
                              ),
                              Text('Type: ${event.type}'),
                              Text('Status: ${event.status}'),
                            ],
                          ),
                        ),

                        // Favourite heart button.
                        trailing: IconButton(
                          icon: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite
                                ? Colors.red
                                : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            toggleFavourite(event);
                          },
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailScreen(
                                    event: event,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Switch between all events and favourite events.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index; // can be 0  or 1
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'All Events',  // 0
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites', // 1
          ),
        ],
      ),
    );
  }
}

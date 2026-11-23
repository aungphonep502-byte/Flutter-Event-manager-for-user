import 'package:shared_preferences/shared_preferences.dart';

class FavouriteService {
  //This key is used to save and find the list of all favourite event IDs on the device.
  static const String _favouriteKey = 'favourite_events';

  // Get all saved favourite event IDs.
  Future<Set<String>> getFavourites() async {
    // Opens local storage.
    final prefs = await SharedPreferences.getInstance();
    // Gets saved favourite IDs, or an empty list if none exist.
    final favourites = prefs.getStringList(_favouriteKey) ?? [];
    // Changes the list into a Set to avoid duplicate IDs.
    return favourites.toSet();
  }

  // Add an event to favourites.
  Future<void> addFavourite(String eventId) async {
    // Opens local storage to access the saved favourite list.
    final prefs = await SharedPreferences.getInstance();
    // store the fav events that users already added
    final favourites = prefs.getStringList(_favouriteKey) ?? [];
    // if chosed event not include in the fav yet,
    // that is added into the fav list
    if (!favourites.contains(eventId)) {
      favourites.add(eventId);
      // Saves the updated favourite list on the device.
      await prefs.setStringList(_favouriteKey, favourites);
    }
  }

  // Remove an event from favourites.
  Future<void> removeFavourite(String eventId) async {
    final prefs = await SharedPreferences.getInstance();

    final favourites = prefs.getStringList(_favouriteKey) ?? [];
    //remove the fav event that user already set
    favourites.remove(eventId);

    await prefs.setStringList(_favouriteKey, favourites);
  }
}

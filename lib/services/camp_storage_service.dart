import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CampStorageService {
  static final CampStorageService _instance = CampStorageService._internal();
  factory CampStorageService() => _instance;
  CampStorageService._internal();

  static const String _campsKey = 'stored_camps';
  List<Map<String, dynamic>> _camps = [];

  // Initialize with hardcoded default camps
  static final List<Map<String, dynamic>> _defaultCamps = [
    {
      "id": 1,
      "name": "Community Health Screening Camp",
      "description":
          "Comprehensive health screening including blood pressure, diabetes, and cholesterol checks. Free consultation with experienced doctors.",
      "date": "Dec 15, 2024",
      "time": "9:00 AM - 4:00 PM",
      "location": "Central Community Center, Downtown",
      "distance": "2.3",
      "type": "General Health",
      "availability": "Available",
      "organizer": "City Health Department",
      "contact": "+1 (555) 123-4567",
      "image":
          "https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": false,
      "registeredCount": 45,
      "maxCapacity": 100,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
    {
      "id": 2,
      "name": "Free Eye Care & Vision Testing",
      "description":
          "Complete eye examination, vision testing, and free reading glasses for eligible participants. Cataract screening available.",
      "date": "Dec 18, 2024",
      "time": "10:00 AM - 3:00 PM",
      "location": "Riverside Medical Plaza",
      "distance": "4.7",
      "type": "Eye Care",
      "availability": "Limited",
      "organizer": "Vision Care Foundation",
      "contact": "+1 (555) 234-5678",
      "image":
          "https://images.pexels.com/photos/5752242/pexels-photo-5752242.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": true,
      "registeredCount": 78,
      "maxCapacity": 80,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
    {
      "id": 3,
      "name": "Dental Health Awareness Camp",
      "description":
          "Free dental checkups, cleaning consultations, and oral health education. Fluoride treatment for children under 12.",
      "date": "Dec 20, 2024",
      "time": "8:00 AM - 5:00 PM",
      "location": "Westside Elementary School",
      "distance": "6.1",
      "type": "Dental",
      "availability": "Available",
      "organizer": "Smile Foundation",
      "contact": "+1 (555) 345-6789",
      "image":
          "https://images.pexels.com/photos/6812540/pexels-photo-6812540.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": false,
      "registeredCount": 23,
      "maxCapacity": 60,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
    {
      "id": 4,
      "name": "Blood Donation Drive",
      "description":
          "Help save lives by donating blood. All blood types needed. Free health screening and refreshments provided for donors.",
      "date": "Dec 22, 2024",
      "time": "11:00 AM - 6:00 PM",
      "location": "Red Cross Center, Main Street",
      "distance": "3.8",
      "type": "Blood Donation",
      "availability": "Available",
      "organizer": "American Red Cross",
      "contact": "+1 (555) 456-7890",
      "image":
          "https://images.pexels.com/photos/6823567/pexels-photo-6823567.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": false,
      "registeredCount": 12,
      "maxCapacity": 50,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
    {
      "id": 5,
      "name": "COVID-19 & Flu Vaccination Camp",
      "description":
          "Free COVID-19 boosters and seasonal flu vaccines. Walk-ins welcome. Bring your vaccination card for record updates.",
      "date": "Dec 25, 2024",
      "time": "9:00 AM - 2:00 PM",
      "location": "Northside Health Clinic",
      "distance": "5.2",
      "type": "Vaccination",
      "availability": "Full",
      "organizer": "County Health Services",
      "contact": "+1 (555) 567-8901",
      "image":
          "https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": true,
      "registeredCount": 120,
      "maxCapacity": 120,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
    {
      "id": 6,
      "name": "Women's Health & Wellness Camp",
      "description":
          "Specialized health screening for women including breast cancer awareness, reproductive health consultation, and nutrition guidance.",
      "date": "Dec 28, 2024",
      "time": "10:00 AM - 4:00 PM",
      "location": "Women's Health Center, Oak Avenue",
      "distance": "7.3",
      "type": "Women's Health",
      "availability": "Available",
      "organizer": "Women's Wellness Foundation",
      "contact": "+1 (555) 678-9012",
      "image":
          "https://images.pexels.com/photos/5452293/pexels-photo-5452293.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isFavorite": false,
      "registeredCount": 34,
      "maxCapacity": 75,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    },
  ];

  // Initialize the service
  Future<void> initialize() async {
    await _loadCamps();

    // If no camps are stored, add default camps
    if (_camps.isEmpty) {
      _camps = List.from(_defaultCamps);
      await _saveCamps();
    }
  }

  // Load camps from local storage
  Future<void> _loadCamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final campsJson = prefs.getString(_campsKey);

      if (campsJson != null) {
        final List<dynamic> campsList = json.decode(campsJson);
        _camps =
            campsList.map((camp) => Map<String, dynamic>.from(camp)).toList();
      }
    } catch (e) {
      // If loading fails, use default camps
      _camps = List.from(_defaultCamps);
    }
  }

  // Save camps to local storage
  Future<void> _saveCamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final campsJson = json.encode(_camps);
      await prefs.setString(_campsKey, campsJson);
    } catch (e) {
      // Handle save error silently
    }
  }

  // Get all camps
  List<Map<String, dynamic>> getAllCamps() {
    return List.from(_camps);
  }

  // Add a new camp
  Future<void> addCamp(Map<String, dynamic> campData) async {
    // Generate unique ID
    final id =
        _camps.isEmpty
            ? 1
            : _camps
                    .map((c) => c['id'] as int)
                    .reduce((a, b) => a > b ? a : b) +
                1;

    final camp = Map<String, dynamic>.from(campData);
    camp['id'] = id;
    camp['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    camp['isFavorite'] = false;
    camp['registeredCount'] = 0;

    _camps.add(camp);
    await _saveCamps();
  }

  // Update an existing camp
  Future<void> updateCamp(int id, Map<String, dynamic> updatedData) async {
    final index = _camps.indexWhere((camp) => camp['id'] == id);
    if (index != -1) {
      _camps[index] = {..._camps[index], ...updatedData};
      await _saveCamps();
    }
  }

  // Delete a camp
  Future<void> deleteCamp(int id) async {
    _camps.removeWhere((camp) => camp['id'] == id);
    await _saveCamps();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int id) async {
    final index = _camps.indexWhere((camp) => camp['id'] == id);
    if (index != -1) {
      _camps[index]['isFavorite'] = !(_camps[index]['isFavorite'] as bool);
      await _saveCamps();
    }
  }

  // Get camps by type
  List<Map<String, dynamic>> getCampsByType(String type) {
    return _camps.where((camp) => camp['type'] == type).toList();
  }

  // Search camps
  List<Map<String, dynamic>> searchCamps(String query) {
    if (query.isEmpty) return getAllCamps();

    final lowerQuery = query.toLowerCase();
    return _camps.where((camp) {
      final name = (camp['name'] as String).toLowerCase();
      final location = (camp['location'] as String).toLowerCase();
      final type = (camp['type'] as String).toLowerCase();
      final organizer = (camp['organizer'] as String).toLowerCase();

      return name.contains(lowerQuery) ||
          location.contains(lowerQuery) ||
          type.contains(lowerQuery) ||
          organizer.contains(lowerQuery);
    }).toList();
  }

  // Get favorite camps
  List<Map<String, dynamic>> getFavoriteCamps() {
    return _camps.where((camp) => camp['isFavorite'] == true).toList();
  }

  // Clear all camps (for testing purposes)
  Future<void> clearAllCamps() async {
    _camps.clear();
    await _saveCamps();
  }

  // Reset to default camps
  Future<void> resetToDefaults() async {
    _camps = List.from(_defaultCamps);
    await _saveCamps();
  }
}

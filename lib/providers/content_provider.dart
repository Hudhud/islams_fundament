import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islams_fundament/data/models/category.dart' as models;

class ContentProvider with ChangeNotifier {
  List<models.Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  List<models.Category> get categories => [..._categories];
  bool get isLoading => _isLoading;
  String? get error => _error;

  ContentProvider() {
    loadContent();
  }

  Future<void> loadContent() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/content.json',
      );
      final data = json.decode(response);
      final List<dynamic> categoryList = data['categories'];

      _categories = categoryList
          .map((json) => models.Category.fromJson(json))
          .toList();
      _error = null;
    } catch (e) {
      _error = "Kunne ikke indlæse indhold. Prøv venligst igen senere.";
      debugPrint('Error loading content: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

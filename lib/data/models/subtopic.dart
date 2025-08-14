import 'package:islams_fundament/data/models/content_page.dart';

class SubTopic {
  final String title;
  final List<ContentPage> pages;

  const SubTopic({required this.title, required this.pages});

  factory SubTopic.fromJson(Map<String, dynamic> json) {
    var pagesList = json['pages'] as List;
    List<ContentPage> pages = pagesList
        .map((p) => ContentPage.fromJson(p))
        .toList();

    return SubTopic(title: json['title'] as String, pages: pages);
  }
}

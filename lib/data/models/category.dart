import 'package:islams_fundament/data/models/subtopic.dart';

class Category {
  final String name;
  final List<SubTopic> topics;

  const Category({required this.name, required this.topics});

  factory Category.fromJson(Map<String, dynamic> json) {
    var topicsList = json['topics'] as List;
    List<SubTopic> topics = topicsList
        .map((t) => SubTopic.fromJson(t))
        .toList();

    return Category(name: json['name'] as String, topics: topics);
  }
}

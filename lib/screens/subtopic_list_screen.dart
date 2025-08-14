import 'package:flutter/material.dart';
import 'package:islams_fundament/data/models/category.dart';
import 'package:islams_fundament/screens/detail_screen.dart';

class SubTopicListScreen extends StatelessWidget {
  final Category category;

  const SubTopicListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final subTopics = category.topics;

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.builder(
        itemCount: subTopics.length,
        itemBuilder: (context, index) {
          final subTopic = subTopics[index];
          return ListTile(
            title: Text(subTopic.title),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(subtopic: subTopic),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

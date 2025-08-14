import 'package:flutter/material.dart';
import '../../../data/content_data.dart';
import 'detail_screen.dart';

class SubTopicListScreen extends StatelessWidget {
  final int categoryIndex;

  const SubTopicListScreen({super.key, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    final subTopics = islamicContent[categoryIndex].topics;

    return Scaffold(
      appBar: AppBar(title: Text(islamicContent[categoryIndex].name)),
      body: ListView.builder(
        itemCount: subTopics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subTopics[index].title),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(subtopic: subTopics[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

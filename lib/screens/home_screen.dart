import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/content_data.dart';
import 'subtopic_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<IconData> categoryIcons = [
    Icons.brightness_high,
    Icons.group,
    Icons.favorite_border,
    Icons.water_drop_outlined,
    Icons.mosque_outlined,
    Icons.access_time_filled,
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              stretch: true,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Islams Fundament',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 2.0),
                        blurRadius: 10.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/home_header.jpg',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: <Color>[Colors.black87, Colors.transparent],
                          stops: [0.0, 0.5],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  left: 16,
                  right: 16,
                  bottom: 8,
                ),
                child: Text(
                  'Vælg et emne',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = islamicContent[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SubTopicListScreen(categoryIndex: index),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            categoryIcons[index],
                            size: 48,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: islamicContent.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

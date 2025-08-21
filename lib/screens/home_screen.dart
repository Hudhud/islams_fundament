import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islams_fundament/widgets/home_screen_questions_widget.dart';
import 'package:provider/provider.dart';
import 'package:islams_fundament/providers/content_provider.dart';
import 'package:islams_fundament/screens/detail_screen.dart';
import 'package:islams_fundament/screens/subtopic_list_screen.dart';
import 'package:islams_fundament/widgets/home_screen_prayer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Set<String> _directOpenCategories = {'Allah', 'Profeterne'};

  static IconData _iconForCategory(String rawName) {
    final iconName = rawName.trim().toLowerCase();

    if (iconName.contains('profet') || iconName.contains('prophet')) {
      return Icons.group;
    }
    if (iconName.contains('konvert') || iconName.contains('convert')) {
      return Icons.favorite_border;
    }
    if (iconName.contains('wudu')) {
      return Icons.water_drop_outlined;
    }
    if (iconName.contains('bøn')) {
      return Icons.mosque_outlined;
    }
    if (iconName.contains('fast')) {
      return Icons.access_time_filled;
    }
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

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
            const SliverToBoxAdapter(child: HomeScreenPrayerWidget()),
            const SliverToBoxAdapter(child: HomeScreenQandAWidget()),
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
            _buildContent(context, contentProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ContentProvider provider) {
    if (provider.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (provider.error != null) {
      return SliverFillRemaining(child: Center(child: Text(provider.error!)));
    }

    final categories = provider.categories;

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];
          final name = category.name.trim();
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                final shouldOpenDetail =
                    _directOpenCategories.contains(name) &&
                    category.topics.isNotEmpty;
                if (shouldOpenDetail) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(subtopic: category.topics.first),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubTopicListScreen(category: category),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (name.toLowerCase() == 'allah')
                    SvgPicture.asset(
                      'assets/icons/Allah_Name_icon.svg',
                      width: 48,
                      height: 48,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    )
                  else
                    Icon(
                      _iconForCategory(name),
                      size: 48,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      name,
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
        }, childCount: categories.length),
      ),
    );
  }
}

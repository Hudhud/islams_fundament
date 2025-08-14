import 'package:flutter/material.dart';
import '../data/models/subtopic.dart';
import '../widgets/audio_player_widget.dart';
import '../core/constants.dart';

class DetailScreen extends StatefulWidget {
  final SubTopic subtopic;

  const DetailScreen({super.key, required this.subtopic});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subtopic.title)),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.subtopic.pages.length,
              itemBuilder: (context, index) {
                final page = widget.subtopic.pages[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (page.pageTitle != null &&
                            page.pageTitle!.isNotEmpty) ...[
                          Text(
                            page.pageTitle!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                        if (page.text != null)
                          Text(
                            page.text!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 24.0),

                        if (page.arabicText != null)
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              page.arabicText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily: 'DroidNaskh',
                                height: 1.8,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16.0),

                        if (page.translationText != null)
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withAlpha((0.05 * 255).round()),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              page.translationText!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        const SizedBox(height: 24.0),

                        if (page.imageName != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              '${AppConstants.imagePath}${page.imageName!}',
                              fit: BoxFit.cover,
                            ),
                          ),

                        if (page.audioName != null &&
                            page.audioName!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: AudioPlayerWidget(
                              audioPath:
                                  '${AppConstants.audioPath}${page.audioName!}',
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.subtopic.pages.length > 1) _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.subtopic.pages.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: _currentPage == index ? 24.0 : 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }
}

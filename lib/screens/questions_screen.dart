import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreen();
}

class _QuestionsScreen extends State<QuestionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String _selectedCategory = "Alle";

  final List<String> _categories = [
    "Alle",
    "Bøn",
    "Koranen",
    "Hadith",
    "Faste",
    "Generelt",
    "Andet",
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Spørgsmål & Svar"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(child: _buildQandAList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskQuestionDialog(context),
        label: const Text('Stil et Spørgsmål'),
        icon: const Icon(Icons.question_answer),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Søg efter spørgsmål...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
              labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQandAList() {
    Query baseQuery = FirebaseFirestore.instance
        .collection('qanda')
        .where('isPublished', isEqualTo: true);

    if (_selectedCategory != "Alle") {
      baseQuery = baseQuery.where('category', isEqualTo: _selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: baseQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Noget gik galt'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Ingen spørgsmål fundet i denne kategori.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final allDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final question = data['question'].toString().toLowerCase();
          return question.contains(_searchText.toLowerCase());
        }).toList();

        final featuredDocs = allDocs
            .where(
              (doc) =>
                  (doc.data() as Map<String, dynamic>)['isFeatured'] == true,
            )
            .toList();
        final regularDocs = allDocs
            .where(
              (doc) =>
                  (doc.data() as Map<String, dynamic>)['isFeatured'] == false,
            )
            .toList();

        return CustomScrollView(
          slivers: [
            if (featuredDocs.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    'Fremhævede Spørgsmål',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doc = featuredDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return QandACard(
                    question: data['question'],
                    answer: data['answer'],
                    answeredAt: data['answeredAt'] as Timestamp?,
                    category: data['category'],
                    isFeatured: data['isFeatured'],
                  );
                }, childCount: featuredDocs.length),
              ),
            ],
            if (regularDocs.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    'Alle Spørgsmål',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: featuredDocs.isEmpty
                          ? Colors.black
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doc = regularDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return QandACard(
                    question: data['question'],
                    answer: data['answer'],
                    answeredAt: data['answeredAt'] as Timestamp?,
                    category: data['category'],
                    isFeatured: data['isFeatured'],
                  );
                }, childCount: regularDocs.length),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showAskQuestionDialog(BuildContext context) {
    final TextEditingController questionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Stil et Nyt Spørgsmål'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: questionController,
              decoration: const InputDecoration(
                hintText: "Skriv dit spørgsmål her...",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Indtast venligst et spørgsmål.';
                }
                return null;
              },
              maxLines: 5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuller'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _submitQuestion(questionController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Indsend'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitQuestion(String question) async {
    try {
      await FirebaseFirestore.instance.collection('qanda').add({
        'question': question,
        'answer': '',
        'isPublished': false,
        'createdAt': FieldValue.serverTimestamp(),
        'answeredAt': null,
        'askedBy': 'anonymous',
        'isFeatured': false,
        'category': 'Andet',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dit spørgsmål er blevet indsendt!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kunne ikke indsende spørgsmål: $e')),
      );
    }
  }
}

class QandACard extends StatelessWidget {
  final String question;
  final String answer;
  final Timestamp? answeredAt;
  final String category;
  final bool isFeatured;

  const QandACard({
    super.key,
    required this.question,
    required this.answer,
    this.answeredAt,
    required this.category,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ExpansionTile(
        leading: isFeatured
            ? const Icon(Icons.star, color: Colors.amber)
            : null,
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(answer, style: const TextStyle(fontSize: 14, height: 1.5)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(category),
                      backgroundColor: Colors.teal.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    if (answeredAt != null)
                      Text(
                        'Besvaret: ${_formatTimestamp(answeredAt!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
}

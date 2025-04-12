import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/recommendations/providers/recommendation_provider.dart';

class AddRecommendationScreen extends ConsumerStatefulWidget {
  const AddRecommendationScreen();

  @override
  _AddRecommendationScreenState createState() => _AddRecommendationScreenState();
}

class _AddRecommendationScreenState extends ConsumerState<AddRecommendationScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _category = 'destination';
  int _rating = 5;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myId = 1; // Replace with actual user ID

    return Scaffold(
      appBar: AppBar(title: const Text('Add Recommendation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _category,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'destination', child: Text('Destination')),
                  DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                  DropdownMenuItem(value: 'airbnb', child: Text('Airbnb')),
                  DropdownMenuItem(value: 'hack', child: Text('Travel Hack')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Rating: '),
                  DropdownButton<int>(
                    value: _rating,
                    items: List.generate(5, (index) => index + 1)
                        .map((rating) => DropdownMenuItem(value: rating, child: Text('$rating')))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _rating = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(recommendationProvider.notifier).addRecommendation(
                        profileId: myId,
                        category: _category,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        location: _locationController.text,
                        rating: _rating,
                      );
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

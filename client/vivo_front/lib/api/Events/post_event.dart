import 'package:flutter/material.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/event.dart';
import 'package:vivo_front/utility/user_functions.dart';
import 'package:vivo_front/types/categories.dart';

class PostEventForm extends StatefulWidget {
  const PostEventForm({super.key});

  @override
  State<PostEventForm> createState() => _PostEventFormState();
}

class _PostEventFormState extends State<PostEventForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  // on mount run function
  // runs on class initialization
  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _dateController = TextEditingController();

  // variable to hold incoming categories
  // user will choose from these in a dropdown, to populate his chosen category array
  List<String> grabbedCategories = List.empty();
  List<String> selectedCategories = [];

  // tags
  // user sort of Hashtags.. They input via a field, and we see them as little buttons like category dropdown
  List<String> selectedTags = [];

  // fetch categories from DB
  Future<void> _getCategories() async {
    try {
      final newEvent = await api.request<Categories, Map<String, dynamic>>(
        endpoint: '/api/categories',
        method: 'GET',
        body: {},
        parser: (json) => Categories.fromJson(json),
      );

      setState(() {
        _resultMessage = '✅ Event created with ID: ${newEvent.categoriesArray}';
        grabbedCategories = newEvent.categoriesArray;
      });
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // add tag helper function
  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty &&
        !selectedTags.contains(tag) &&
        selectedTags.length < 3) {
      setState(() {
        selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  // call get Categories to populate dropdown for categories

  bool _isSubmitting = false;
  String _resultMessage = '';

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _resultMessage = '';
    });

    try {
      // get user id
      final userId = getCurrentUserId();

      print('Current user ID: $userId');

      final newEvent = await api.request<EventVivo, Map<String, dynamic>>(
        endpoint: '/api/events',
        method: 'POST',
        body: {
          'userId': userId, // TODO: replace with actual user ID
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tags': _tagsController.text,
          'categories': selectedCategories,
          'date': _dateController.text,
        },
        parser: (json) => EventVivo.fromJson(json),
      );

      setState(() {
        _resultMessage = '✅ Event created with ID: ${newEvent.id}';
      });

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _tagsController.clear();
      _categoriesController.clear();
      _dateController.clear();
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _categoriesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter description' : null,
          ),
          TextFormField(
            controller: _tagsController,
            decoration: const InputDecoration(labelText: 'Tags'),
          ),
          TextFormField(
            controller: _categoriesController,
            decoration: const InputDecoration(labelText: 'Categories'),
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Date'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // Display selected categories as removable chips
              Wrap(
                spacing: 8,
                children: selectedCategories.map((category) {
                  return Chip(
                    label: Text(category),
                    onDeleted: () {
                      setState(() {
                        selectedCategories.remove(category);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // Button to select more categories
              ElevatedButton.icon(
                onPressed: () async {
                  final chosen = await showDialog<List<String>>(
                    context: context,
                    builder: (context) {
                      // Local temp list to track selections in the dialog
                      List<String> tempSelected = List.from(selectedCategories);

                      return AlertDialog(
                        title: const Text('Select Categories'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: grabbedCategories.map((category) {
                              return CheckboxListTile(
                                value: tempSelected.contains(category),
                                title: Text(category),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true &&
                                        tempSelected.length < 3) {
                                      tempSelected.add(category);
                                    } else {
                                      tempSelected.remove(category);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(context, tempSelected),
                            child: const Text('Done'),
                          ),
                        ],
                      );
                    },
                  );

                  if (chosen != null) {
                    setState(() {
                      selectedCategories = chosen;
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Select Categories'),
              ),

              if (selectedCategories.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select at least one category',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),

              // Display entered tags as chips
              Wrap(
                spacing: 8,
                children: selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() {
                        selectedTags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // Input field for adding new tags
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(labelText: 'Add a tag'),
                      onFieldSubmitted: (value) {
                        _addTag();
                      },
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.add), onPressed: _addTag),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitEvent,
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Submit Event'),
          ),
          const SizedBox(height: 20),
          if (_resultMessage.isNotEmpty)
            Text(
              _resultMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

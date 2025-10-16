import 'package:flutter/material.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/event.dart';

class PostEventForm extends StatefulWidget {
  const PostEventForm({super.key});

  @override
  State<PostEventForm> createState() => _PostEventFormState();
}

class _PostEventFormState extends State<PostEventForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isSubmitting = false;
  String _resultMessage = '';

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _resultMessage = '';
    });

    try {
      final newEvent = await api.request<EventVivo, Map<String, dynamic>>(
        endpoint: '/api/events',
        method: 'POST',
        body: {
          'userId': 1, // TODO: replace with actual user ID
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tags': _tagsController.text,
          'categories': _categoriesController.text,
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
            validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitEvent,
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Submit Event'),
          ),
          const SizedBox(height: 20),
          if (_resultMessage.isNotEmpty)
            Text(_resultMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

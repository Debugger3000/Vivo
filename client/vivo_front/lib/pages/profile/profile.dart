import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/api/api_service.dart'; // your ApiService
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/api/Events/post_event.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  // Controllers for the form fields
  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _tagsController = TextEditingController();
  // final TextEditingController _categoriesController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();

  // bool _isSubmitting = false;
  // String _resultMessage = '';

  // Future<void> _submitEvent() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isSubmitting = true;
  //     _resultMessage = '';
  //   });

  //   try {
  //     final newEvent = await api.request<EventVivo, Map<String, dynamic>>(
  //       endpoint: '/api/events', // replace with your real API endpoint
  //       method: 'POST',
  //       body: {
  //         'userId': 1, // replace with actual user ID from auth if needed
  //         'title': _titleController.text,
  //         'description': _descriptionController.text,
  //         'tags': _tagsController.text,
  //         'categories': _categoriesController.text,
  //         'date': _dateController.text,
  //       },
  //       parser: (json) => EventVivo.fromJson(json),
  //     );

  //     setState(() {
  //       _resultMessage = 'Event created with ID: ${newEvent.id}';
  //     });

  //     // Optionally clear the form
  //     _titleController.clear();
  //     _descriptionController.clear();
  //     _tagsController.clear();
  //     _categoriesController.clear();
  //     _dateController.clear();
  //   } catch (e) {
  //     setState(() {
  //       _resultMessage = 'Error: $e';
  //     });
  //   } finally {
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   _tagsController.dispose();
  //   _categoriesController.dispose();
  //   _dateController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile / Create Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [

                  // display EVENT POST FORM
                  const PostEventForm()
                  // TextFormField(
                  //   controller: _titleController,
                  //   decoration: const InputDecoration(labelText: 'Title'),
                  //   validator: (value) =>
                  //       value == null || value.isEmpty ? 'Enter title' : null,
                  // ),
                  // TextFormField(
                  //   controller: _descriptionController,
                  //   decoration: const InputDecoration(labelText: 'Description'),
                  //   validator: (value) =>
                  //       value == null || value.isEmpty ? 'Enter description' : null,
                  // ),
                  // TextFormField(
                  //   controller: _tagsController,
                  //   decoration: const InputDecoration(labelText: 'Tags'),
                  // ),
                  // TextFormField(
                  //   controller: _categoriesController,
                  //   decoration: const InputDecoration(labelText: 'Categories'),
                  // ),
                  // TextFormField(
                  //   controller: _dateController,
                  //   decoration: const InputDecoration(labelText: 'Date'),
                  // ),
          
                  // const SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: _isSubmitting ? null : _submitEvent,
                  //   child: _isSubmitting
                  //       ? const CircularProgressIndicator()
                  //       : const Text('Submit Event'),
                  // ),
                  // const SizedBox(height: 20),
                  // if (_resultMessage.isNotEmpty)
                  //   Text(_resultMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () async {
                // 🔐 Sign out from Supabase
                await Supabase.instance.client.auth.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/api/api_service.dart'; // your ApiService
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/api/Events/post_event.dart';
import 'dart:developer' as developer;
import 'package:vivo_front/main.dart';




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  final GlobalKey<PostEventFormState> postEventFormKey = GlobalKey<PostEventFormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when returning to this page
  @override
  void didPopNext() {
    developer.log("Post event form has ran hehe", name:'vivo-loggy', level: 0);
    print("did pop next in profile.... calling get CATTERsss");
    // Calls _getCategories on the PostEventForm component
    postEventFormKey.currentState?.getCategories();
  }


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
                  const PostEventForm(),
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

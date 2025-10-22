import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/api/api_service.dart'; // your ApiService
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/api/Events/post_event.dart';
import 'package:vivo_front/com_ui_widgets/mainpage_header.dart';
import 'dart:developer' as developer;
import 'package:vivo_front/main.dart';
import 'package:vivo_front/stateless/generic_callback_button.dart';
import 'package:vivo_front/com_ui_widgets/subpage_header.dart';



class ProfileTab extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileTab({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/profile',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/profile':
            builder = (context) => ProfilePage(); // Your main map UI
            break;
          case '/settings':
            builder = (context) => PostEventForm(); // Subpage to push
            break;
          default:
            builder = (context) => ProfilePage();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  // final _formKey = GlobalKey<FormState>();
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

  // ----------------------

  // Supabase logout logic
  void logout(BuildContext context) async {
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: 
          GenericCallBackButton(name: 'Logout', onPressed: () => logout(context)), // use generic call back button...
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/get_events.dart';
import 'package:vivo_front/pages/events/CRUD/patch_event.dart';
import 'package:vivo_front/pages/events/CRUD/post_event.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/com_ui_widgets/mainpage_header.dart';
import 'package:vivo_front/pages/events/event_fullview.dart';
import 'package:vivo_front/types/event.dart';


class EventsTab extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const EventsTab({super.key, required this.navigatorKey});

  

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/events',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/events':
            builder = (context) => EventsPage(); // Your main map UI
            break;
          case '/post_event':
            builder = (context) => PostEventForm(); // Subpage to push
            break;
          case '/edit_event':
            final event = settings.arguments as GetEventPreview; //pass data to this widget page on nav
            builder = (context) => PatchEventForm(event: event); // Subpage to push
            break;
          case '/view_event':
            final event = settings.arguments as GetEventPreview; //pass data to this widget page on nav
            builder = (context) => EventFullView(event: event); // Subpage to push
            break;
          default:
            builder = (context) => EventsPage();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}





class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsState();
}

class _EventsState extends State<EventsPage> {

  final ApiService api = ApiService(); 

  List<GetEventPreview> eventsList = [];
  // bool _loading = true;
  // String? _error;

  int increTest = 0;


  @override
  void initState() {
    super.initState();
    _loadEvents();
      print("after get events after post frame");
  }

  // -------------------------------------------

  Future<void> _loadEvents() async {
    final events = await getEvents(api);
    setState(() {
      print("-------------set state for events list----------");
      eventsList = events;
      for (var e in eventsList) {
      print('Event: ${e.id}, ${e.title}, ${e.startTime} → ${e.endTime}, ${e.address}');
      }
    });
  }


  void _goToCreate() async {
    await Navigator.of(context).pushNamed('/post_event');
    // Reload events after returning
    // await _load();
  }

  

  // full view for an event...
  void _goToEventPage(GetEventPreview event) async {
    print('going to full view event page...');
    final updatedEvent = await Navigator.pushNamed(
      context,
      '/view_event',
      arguments: event,
    ) as GetEventPreview?;

    // // Execution resumes here after the page is popped
    // if (updatedEvent != null) {
    //   setState(() {
    //     // update your events list
    //     final index = eventsList.indexWhere((e) => e.id == updatedEvent.id);
    //     if (index != -1) eventsList[index] = updatedEvent;
    //   });
    // }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainPageHeader(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Create event'),
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                final event = eventsList[index];
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.title),
                  subtitle: Text(
                      '${event.startTime} → ${event.endTime}\n${event.description}'),
                  isThreeLine: true,
                  trailing: Text('${event.interested} 👍'),
                  onTap: () {
                    _goToEventPage(event);
                  },
                );
              },
          ),
          ),
        ]
          
      ),
    );
  }
}
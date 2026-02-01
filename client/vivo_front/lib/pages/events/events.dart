
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
    
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToCreate,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Create event'),
      // ),
      floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                 _goToCreate();
              },
              // shape: CircleBorder(
              //   side: BorderSide(color: Colors.grey.shade200, width: 4),
              // ),
              backgroundColor: Colors.grey.shade200,
              icon: const Icon(Icons.add,color: Colors.blue),
              label: const Text('Create Event', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
            ),
      body: Column(
        children: [

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: eventsList.length,
          //     itemBuilder: (context, index) {
          //       final event = eventsList[index];
          //       return ListTile(
          //         leading: const Icon(Icons.event),
          //         title: Text(event.title),
          //         subtitle: Text(
          //             '${event.startTime} → ${event.endTime}\n${event.description}'),
          //         isThreeLine: true,
          //         trailing: Text('${event.interested} 👍'),
          //         onTap: () {
          //           _goToEventPage(event);
          //         },
          //       );
          //     },
          // ),
          // ),
          Expanded(
  child: ListView.separated(
    padding: const EdgeInsets.only(bottom: 100),
    itemCount: eventsList.length,
    separatorBuilder: (_, __) => const Divider(
      thickness: 1.5,
      height: 1,
      color: Colors.black,
    ),
    itemBuilder: (context, index) {
      final event = eventsList[index];

      return InkWell(
        onTap: () => _goToEventPage(event),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Event Image
              Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(112),
              ),
              child: const Icon(Icons.event, size: 58),
            ),


              const SizedBox(width: 16),

              /// Event Title
              Expanded(
                child: Text(
                  event.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

        ]
          
      ),
    );
  }
}
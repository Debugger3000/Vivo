import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/post_event.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/com_ui_widgets/mainpage_header.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
    //getEvents();
  }

  Future<void> _load() async {
    // setState(() {
    //   _loading = true;
    //   _error = null;
    // });

    try {
      await getEvents();
    } catch (e) {
      //_error = e.toString();
    } finally {
      // setState(() {
      //   _loading = false;
      // });
    }
  }


  // getEvent previews for markers
  Future<void> getEvents() async {
    try {


    //   setState(() {
    //   _loading = true;
    //   _error = null;
    // });

      print('calling get events preview....................');
      final events = await api.requestList<GetEventPreview>(
        endpoint: '/api/events-preview',
        parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
      );

      // print("printer;categories returned: $categories");
      // developer.log("GET returned response: $categories", name:'vivo-loggy', level: 0);
      print("returned GET event page: events............................................");
      print(events);

      

      // IMPORTANT: setState() should be used to update UI / core to flutter/dart lifecycle...
      setState(() {
        print("--------------setting events data---------------");
        // _loading = false;
        eventsList = events;
      });
    } catch (e) {
      print('error on getEvents in map.dart: $e');
    } finally {
      // setState(() {
      //   // _isSubmitting = false;
      //   print("done get events");
      // });
    }
  }

  void _goToCreate() async {
    await Navigator.of(context).pushNamed('/post_event');
    // Reload events after returning
    // await _load();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainPageHeader(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Post event'),
      ),
      body: 
          ListView.builder(
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
                    // Handle tap if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped: ${event.title}')),
                    );
                  },
                );
              },
            ),
    );
  }
}

class EventsListView extends StatelessWidget {
  final List<GetEventPreview> events;
  final Future<void> Function() onRefresh;
  final void Function(GetEventPreview)? onTap;

  const EventsListView({
    super.key,
    required this.events,
    required this.onRefresh,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: events.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final e = events[i];
          return EventListTile(event: e, onTap: () => onTap?.call(e));
        },
      ),
    );
  }
}

class EventListTile extends StatelessWidget {
  final GetEventPreview event;
  final VoidCallback? onTap;

  const EventListTile({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = _titleOf(event);
    final start = _startOf(event);
    final end   = _endOf(event);
    final range = _formatRange(start, end);

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.event)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (range != null) ...[
            const SizedBox(height: 4),
            Text(range),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

String _titleOf(GetEventPreview e) {
  try {
    final m = (e as dynamic);
    return (m.title ?? m.name ?? 'Untitled').toString();
  } catch (_) {
    return 'Untitled';
  }
}

DateTime? _startOf(GetEventPreview e) {
  try {
    final m = (e as dynamic);
    final raw = (m.startTime ?? m.start_time ?? m.starts_at ?? m.start);
    return _toDateTime(raw);
  } catch (_) {
    return null;
  }
}

DateTime? _endOf(GetEventPreview e) {
  try {
    final m = (e as dynamic);
    final raw = (m.endTime ?? m.end_time ?? m.ends_at ?? m.end);
    return _toDateTime(raw);
  } catch (_) {
    return null;
  }
}

DateTime? _toDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is String) { try { return DateTime.parse(v); } catch (_) {} }
  return null;
}

String? _formatRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return null;

  String two(int n) => n.toString().padLeft(2, '0');
  String day(DateTime d) => '${d.year}/${two(d.month)}/${two(d.day)}';
  String time(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

  if (start != null && end != null) {
    final sameDay = start.year == end.year && start.month == end.month && start.day == end.day;
    return sameDay
        ? '${day(start)}  ${time(start)} – ${time(end)}'
        : '${day(start)}  ${time(start)} → ${day(end)}  ${time(end)}';
  }
  final d = start ?? end!;
  return '${day(d)}  ${time(d)}';
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 48),
            const SizedBox(height: 12),
            const Text('No events yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Post your first event to get started.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Post event'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String? detail;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, this.detail, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            if ((detail ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(detail!, textAlign: TextAlign.center, style: TextStyle(color: outline)),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

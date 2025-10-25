import 'package:flutter/material.dart';
import 'package:vivo_front/com_ui_widgets/event_chip.dart';
import 'package:vivo_front/types/event.dart';



class EventWindow extends StatefulWidget {
  // receive an event data to display
  final GetEventPreview event;
  final void Function(int) cycleEvent; // send back to map.dart, to swap a new event into event window...
  final VoidCallback closeWindow;
  const EventWindow({super.key, required this.event, required this.cycleEvent, required this.closeWindow});

  @override
  State<EventWindow> createState() => _EventWindowState();
}

class _EventWindowState extends State<EventWindow> {

   bool _loading = false;


  @override
  Widget build(BuildContext context) {
    return Align(
    alignment: Alignment.center,
    child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity == null) return;

          // Swipe up
          if (details.primaryVelocity! < 0) {
            // negative velocity = swipe up
            print('swipe upppppp');
            widget.cycleEvent(1); // next event
          }
          // Swipe down
          else if (details.primaryVelocity! > 0) {
            print('swipe downnn');
            widget.cycleEvent(-1); // previous event
          }
        },
        child: Container(
          width: 350,
          height: 500,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: Colors.black26),
            ],
          ),
          child: Stack(
            children: [
              // X button top-left
              Positioned(
                top: 0,
                left: -15,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => widget.closeWindow(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.event.description),
                    const SizedBox(height: 8),
                    Text("Address: ${widget.event.address}"),
                    const SizedBox(height: 8),
                    Text("Start: ${widget.event.startTime}  |  End: ${widget.event.endTime}"),
                    const SizedBox(height: 8),
                    Text("Interested: ${widget.event.interested}"),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: widget.event.categories.map((category) => EventChip(label: category)).toList(),
                    ),
                    Wrap(
                      spacing: 6,
                      children: widget.event.tags.map((tag) => EventChip(label: tag, isCategory: false)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
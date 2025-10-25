import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivo_front/com_ui_widgets/animations/pulsing_dot.dart';

// enum for type of time displays...
enum TimeDisplayType { live, today, tomorrow, days }

class TimeDisplay extends StatelessWidget {
  final String startTime; // takes UTC string
  final String endTime; // takes UTC string



  //final TimeDisplayType type; // type to display (Days away, today, LIVE)
  const TimeDisplay({
    super.key,
    required this.startTime,
    required this.endTime,
  }); // ← initializer list


  // sort date and return 'type'
  TimeDisplayType sortTimes() {
    DateTime curTime = DateTime.now(); // cur time to use to compare with...
    DateTime startTime = DateTime.parse(this.startTime).toLocal(); // start time
    DateTime endTime = DateTime.parse(this.endTime).toLocal(); // end time


    // LIVE → curTime is between start and end
    if (curTime.isAfter(startTime) && curTime.isBefore(endTime)) {
      return TimeDisplayType.live;
    }

    // TODAY → same day as start, but curTime is before startTime
    if (curTime.year == startTime.year &&
        curTime.month == startTime.month &&
        curTime.day == startTime.day &&
        curTime.isBefore(startTime)) {
      return TimeDisplayType.today;
    }

    // DAYS → curTime is before startTime but not today
    if (curTime.isBefore(startTime)) {
      return TimeDisplayType.days;
    }

    // Optional: if curTime is after endTime, you could return "past" or "days" again
    return TimeDisplayType.live;
  }


  // LIVE - events
    // red Live text - 'animated red dot with glow happening around it...'

  // Today - Event display
    // Green 'Today' - 'timeframe'

  // Tomorrow - 
    // not green, but maybe a blue ???? idkk... ( Tomorrow - start Time (may 4th, 8:00 am))


  // Days away - display basic time for an event tomorrow, or in days - weeks time...
    // may 4th, 8:00 am - 10:00 am
    // may 4th, 8:00 am - May 5th 4:00 pm


  

  

  // old - event
    // event has finished.... ???




  @override
  Widget build(BuildContext context) {

    TimeDisplayType type = sortTimes();



    // what type to dispaly...
    switch (type) {
      case TimeDisplayType.live:
        // build the "LIVE" style
        return _buildLiveDisplay();

      case TimeDisplayType.today:
        // build the "Today" style
        return _buildTodayDisplay();
      
      case TimeDisplayType.tomorrow:
        return _buildTomorrowDisplay();

      case TimeDisplayType.days:
        // build the "Days away" style
        return _buildDaysDisplay();
    }
  }

  // 
Widget _buildBasicTime() {
  // Convert to local time
  DateTime startTime = DateTime.parse(this.startTime).toLocal();
  DateTime endTime = DateTime.parse(this.endTime).toLocal();

  // Format date & time
  final dateFormat = DateFormat.MMMd(); // "May 8"
  final timeFormat = DateFormat.jm();   // "8:00 AM"

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Line 1: start date & time
        Text(
          "Start: ${dateFormat.format(startTime)} - ${timeFormat.format(startTime)}",
          style: const TextStyle(
          ),
        ),
        const SizedBox(height: 4), // spacing between start & end
        // Line 2: end date & time
        Text(
          "End: ${dateFormat.format(endTime)} - ${timeFormat.format(endTime)}",
        ),
      ],
    ),
  );
}






  // 👇 Each helper function returns a Widget

Widget _buildLiveDisplay() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    // mainAxisSize: MainAxisSize.min,
    children: [
      
      // Row for red dot + LIVE text, vertically aligned
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(width: 10), // make sure pulsing dot is farther to the right so it doesnt hit padding
          // Icon(Icons.circle, color: Colors.red, size: 12),
          PulsingDot(),
          SizedBox(width: 6),
          Text(
            'LIVE',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      // _buildBasicTime() below, aligned with text (not dot)
      
      _buildBasicTime(),
      
    ],
  );
}


  Widget _buildTodayDisplay() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_available, color: Colors.green, size: 14),
        SizedBox(width: 6),
        Text(
          'Today',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTomorrowDisplay() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_available, color: Colors.green, size: 14),
        SizedBox(width: 6),
        Text(
          'Tomorrow',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDaysDisplay() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_month, color: Colors.blueGrey, size: 14),
        SizedBox(width: 6),
        Text(
          'In a few days',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ],
    );
  }




}

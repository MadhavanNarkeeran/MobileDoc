import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDisplay extends StatelessWidget {
  const CalendarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: SfCalendar(
        view: CalendarView.month
      )
    );
  }
}
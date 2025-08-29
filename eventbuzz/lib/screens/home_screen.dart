import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onRegister;

  HomeScreen({required this.events, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index], onRegister: onRegister);
      },
    );
  }
}

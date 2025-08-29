import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Function(Event) onRegister;

  EventCard({required this.event, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text("${event.date} • ${event.location}"),
        trailing: ElevatedButton(
          onPressed: () => onRegister(event),
          child: Text("Register"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/event_model.dart';

class MyEventsScreen extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onCancel;

  MyEventsScreen({required this.events, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return Center(child: Text("No registered events"));

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(e.title),
            subtitle: Text("Status: Registered"),
            trailing: TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => onCancel(e),
            ),
          ),
        );
      },
    );
  }
}

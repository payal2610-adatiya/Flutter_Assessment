import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_events_screen.dart';
import 'profile_screen.dart';
import 'add_event_screen.dart';
import '../models/event_model.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  DashboardScreen({required this.onThemeToggle});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Event> allEvents = [
    Event(title: "Tech Conference 2025", date: "Sep 15", location: "San Francisco"),
    Event(title: "Music Festival", date: "Oct 1", location: "New York"),
  ];
  List<Event> registeredEvents = [];

  void _addEvent(Event event) {
    setState(() {
      allEvents.add(event);
    });
  }

  void _registerEvent(Event event) {
    setState(() {
      registeredEvents.add(event);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered for ${event.title}")));
  }

  void _cancelEvent(Event event) {
    setState(() {
      registeredEvents.remove(event);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cancelled ${event.title}")));
  }
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(onThemeToggle: widget.onThemeToggle),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(events: allEvents, onRegister: _registerEvent),
      MyEventsScreen(events: registeredEvents, onCancel: _cancelEvent),
      ProfileScreen(onThemeToggle: widget.onThemeToggle),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("EventBuzz"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "My Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEventScreen()),
          );
          if (newEvent != null) _addEvent(newEvent);
        },
      )
          : null,
    );
  }
}

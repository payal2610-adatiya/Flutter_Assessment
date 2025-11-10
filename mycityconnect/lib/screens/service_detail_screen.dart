import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  File? _picked;
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _booking = false;

  Future<void> _pick(ImageSource s) async {
    final p = await _picker.pickImage(source: s, maxWidth: 1200);
    if (p != null) setState(() => _picked = File(p.path));
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _selectedDate = date;
      _selectedTime = time;
    });
  }

  Future<void> _bookService(Map<String, dynamic> service) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time')),
      );
      return;
    }

    setState(() => _booking = true);

    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'serviceId': service['id'],
        'serviceName': service['name'],
        'category': service['category'],
        'bookingDate': dt.toIso8601String(),
        'status': 'Confirmed',
        'contact': service['phone'] ?? '',
        'image': service['image'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(args['name'] ?? 'Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (args['image'] != null && args['image'] != '')
              Image.asset(args['image'], height: 200, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              '${args['category'] ?? ''} • ${args['city'] ?? ''}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _picked != null
                ? Image.file(_picked!, height: 160)
                : const Text('No uploaded image (stored locally)'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _selectDateTime(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date & Time'
                  : '${_selectedDate!.toLocal().toString().split(' ')[0]} ${_selectedTime?.format(context) ?? ''}'),
            ),
            const SizedBox(height: 12),
            _booking
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: () => _bookService(args),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book This Service'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final phone = args['phone'] ?? '';
                if (phone != '') {
                  final uri = Uri.parse('tel:$phone');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                }
              },
              icon: const Icon(Icons.call),
              label: const Text('Call Provider'),
            ),
          ],
        ),
      ),
    );
  }
}

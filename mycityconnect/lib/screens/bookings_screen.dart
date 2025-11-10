import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    // If user is not logged in
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please log in to view your bookings.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('bookingDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No bookings yet.\nBook a service to see it here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {

              final data = bookings[index].data() as Map<String, dynamic>;

              // Safe parsing of date
              DateTime? bookingDate;
              try {
                bookingDate = DateTime.parse(data['bookingDate']);
              } catch (_) {}

              final formattedDate = bookingDate != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(bookingDate)
                  : 'Unknown date';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: data['image'] != null
                        ? Image.asset(
                      data['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported,
                            size: 40, color: Colors.grey);
                      },
                    )
                        : const Icon(Icons.store, size: 40, color: Colors.grey),
                  ),
                  title: Text(
                    data['serviceName'] ?? 'Service Name',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Category: ${data['category'] ?? 'N/A'}\n'
                          'Date: $formattedDate\n'
                          'Status: ${data['status'] ?? 'Pending'}',
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'cancel') {
                        await _firestore
                            .collection('bookings')
                            .doc(bookings[index].id)
                            .update({'status': 'Cancelled'});
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Booking cancelled successfully')),
                          );
                        }
                      } else if (value == 'delete') {
                        await _firestore
                            .collection('bookings')
                            .doc(bookings[index].id)
                            .delete();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booking deleted')),
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel Booking'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Booking'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

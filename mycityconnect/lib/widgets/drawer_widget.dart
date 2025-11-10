import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _name = 'Guest';
  String _email = 'guest@example.com';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _email = user.email ?? _email;
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      setState(() {
        _name = (data!=null && data['name']!=null) ? data['name'] : (user.displayName ?? _email.split('@').first);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
              accountName: Text(_name),
              accountEmail: Text(_email),
              onDetailsPressed: () {},
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: ()=> Navigator.pushReplacementNamed(context, '/home')),
            ListTile(leading: const Icon(Icons.book), title: const Text('My Bookings'), onTap: ()=> Navigator.pushNamed(context, '/bookings')),
            ListTile(leading: const Icon(Icons.person), title: const Text('Profile'), onTap: ()=> Navigator.pushNamed(context, '/profile')),
            ListTile(leading: const Icon(Icons.contact_phone), title: const Text('Contact Us'), onTap: ()=> Navigator.pushNamed(context, '/contact')),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: (){
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
    );
  }
}

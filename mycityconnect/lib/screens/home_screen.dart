import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/service_bloc.dart';
import '../models/service_model.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    print("Current UID: ${FirebaseAuth.instance.currentUser?.uid}");

    return Scaffold(
      appBar: AppBar(title: const Text('MyCityConnect')),
      drawer: const AppDrawer(),
      body: SafeArea(

        child: BlocBuilder<ServiceBloc, dynamic>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceLoaded) {
              final List<ServiceModel> services = state.services;
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: services.length,
                itemBuilder: (context, idx) {
                  final s = services[idx];
                  return ServiceCard(service: s, onTap: () => Navigator.pushNamed(context, '/details', arguments: s.toMap()));
                },
              );
            } else if (state is ServiceError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No services found'));
          },
        ),
      ),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/service_model.dart';

abstract class ServiceEvent {}
class LoadServices extends ServiceEvent {}

abstract class ServiceState {}
class ServiceInitial extends ServiceState {}
class ServiceLoading extends ServiceState {}
class ServiceLoaded extends ServiceState {
  final List<ServiceModel> services;
  ServiceLoaded(this.services);
}
class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceInitial()) {
    on<LoadServices>((event, emit) async {
      emit(ServiceLoading());
      try {
        final jsonStr = await rootBundle.loadString('assets/services_india.json');
        final data = json.decode(jsonStr) as List<dynamic>;
        final services = data.map((e) => ServiceModel.fromMap(e as Map<String, dynamic>)).toList();
        emit(ServiceLoaded(services));
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });
  }
}

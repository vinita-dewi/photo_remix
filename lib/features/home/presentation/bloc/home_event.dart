import 'package:equatable/equatable.dart';

// Base event class for home feature
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// Initial event
class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
}


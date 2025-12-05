import 'package:equatable/equatable.dart';

// Base state class for home feature
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

// Loaded state
class HomeLoaded extends HomeState {
  const HomeLoaded();
}

// Error state
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}


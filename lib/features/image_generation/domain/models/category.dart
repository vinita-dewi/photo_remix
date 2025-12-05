import 'package:equatable/equatable.dart';

/// Category model for image generation presets.
class Category extends Equatable {
  final String id;
  final String name;

  const Category({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

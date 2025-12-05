import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageGenEvent extends Equatable {
  const ImageGenEvent();

  @override
  List<Object?> get props => [];
}

class PickFromGallery extends ImageGenEvent {
  const PickFromGallery();
}

class PickFromCamera extends ImageGenEvent {
  const PickFromCamera();
}

class ImagePicked extends ImageGenEvent {
  final XFile file;
  const ImagePicked(this.file);

  @override
  List<Object?> get props => [file.path];
}

class ClearImage extends ImageGenEvent {
  const ClearImage();
}

class GenerateImageRequested extends ImageGenEvent {
  const GenerateImageRequested();
}

class CategorySelected extends ImageGenEvent {
  final String categoryId;
  final String categoryName;

  const CategorySelected({required this.categoryId, required this.categoryName});

  @override
  List<Object?> get props => [categoryId, categoryName];
}

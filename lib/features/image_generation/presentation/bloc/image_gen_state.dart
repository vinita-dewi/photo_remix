import 'package:equatable/equatable.dart';

class ImageGenState extends Equatable {
  final String? imagePath;
  final bool isLoading;
  final String? error;
  final String? categoryId;
  final String? categoryName;
  final bool showResult;

  const ImageGenState({
    this.imagePath,
    this.isLoading = false,
    this.error,
    this.categoryId,
    this.categoryName,
    this.showResult = false,
  });

  factory ImageGenState.initial() => const ImageGenState();

  ImageGenState copyWith({
    String? imagePath,
    bool? isLoading,
    String? error,
    String? categoryId,
    String? categoryName,
    bool? showResult,
  }) {
    return ImageGenState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      showResult: showResult ?? this.showResult,
    );
  }

  @override
  List<Object?> get props =>
      [imagePath, isLoading, error, categoryId, categoryName, showResult];
}

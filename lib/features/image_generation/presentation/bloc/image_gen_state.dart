import 'package:equatable/equatable.dart';

class ImageGenState extends Equatable {
  final String? imagePath;
  final bool isLoading;
  final bool isGenerating;
  final String? error;
  final String? categoryId;
  final String? categoryName;
  final bool showResult;
  final List<String> generatedImageUrls;
  final String? originalImageId;

  const ImageGenState({
    this.imagePath,
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
    this.categoryId,
    this.categoryName,
    this.showResult = false,
    this.generatedImageUrls = const [],
    this.originalImageId,
  });

  factory ImageGenState.initial() => const ImageGenState();

  ImageGenState copyWith({
    String? imagePath,
    bool? isLoading,
    bool? isGenerating,
    String? error,
    String? categoryId,
    String? categoryName,
    bool? showResult,
    List<String>? generatedImageUrls,
    String? originalImageId,
  }) {
    return ImageGenState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      showResult: showResult ?? this.showResult,
      generatedImageUrls: generatedImageUrls ?? this.generatedImageUrls,
      originalImageId: originalImageId ?? this.originalImageId,
    );
  }

  @override
  List<Object?> get props => [
        imagePath,
        isLoading,
        isGenerating,
        error,
        categoryId,
        categoryName,
        showResult,
        generatedImageUrls,
        originalImageId,
      ];
}

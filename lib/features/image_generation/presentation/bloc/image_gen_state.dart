import 'package:equatable/equatable.dart';

class ImageGenState extends Equatable {
  final String? imagePath;
  final bool isLoading;
  final bool isGenerating;
  final String? error;
  final String? categoryId;
  final String? categoryName;
  final bool showResult;
  final double progress;

  const ImageGenState({
    this.imagePath,
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
    this.categoryId,
    this.categoryName,
    this.showResult = false,
    this.progress = 0.0,
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
    double? progress,
  }) {
    return ImageGenState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      showResult: showResult ?? this.showResult,
      progress: progress ?? this.progress,
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
        progress,
      ];
}

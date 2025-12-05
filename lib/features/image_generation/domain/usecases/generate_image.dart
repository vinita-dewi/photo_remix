import '../repositories/image_generation_repository.dart';

class GenerateImage {
  final ImageGenerationRepository repository;

  GenerateImage(this.repository);

  Future<void> call({
    required String categoryId,
    required String categoryName,
    required String imagePath,
  }) {
    return repository.generateImage(
      categoryId: categoryId,
      categoryName: categoryName,
      imagePath: imagePath,
    );
  }
}
